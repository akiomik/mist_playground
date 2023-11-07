import gleam/bytes_builder
import gleam/erlang/process
import gleam/http/response.{type Response}
import gleam/http/request.{type Request}
import gleam/io
import gleam/option.{Some}
import gleam/otp/actor
import mist.{type Connection, type ResponseData}

pub fn main() {
  // These values are for the Websocket process initialized below
  let selector = process.new_selector()
  let state = Nil

  let not_found =
    response.new(404)
    |> response.set_body(mist.Bytes(bytes_builder.new()))

  let assert Ok(_) =
    fn(req: Request(Connection)) -> Response(ResponseData) {
      case request.path_segments(req) {
        // root
        [] ->
          mist.websocket(
            request: req,
            on_init: fn() { #(state, Some(selector)) },
            on_close: fn() { io.println("goodbye!") },
            handler: handle_ws_message,
          )

        _ -> not_found
      }
    }
    |> mist.new
    |> mist.port(3000)
    |> mist.start_http

  process.sleep_forever()
}

fn handle_ws_message(state, conn, message) {
  case message {
    mist.Text(<<"ping":utf8, _:bits>>) -> {
      let assert Ok(_) = mist.send_text_frame(conn, <<"pong":utf8>>)
      actor.continue(state)
    }
    mist.Text(_) | mist.Binary(_) | mist.Custom(_) -> actor.continue(state)
    mist.Closed | mist.Shutdown -> actor.Stop(process.Normal)
  }
}
