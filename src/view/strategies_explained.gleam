import lustre/element
import lustre/element/html
import mvu

pub fn get(_model: mvu.Model) -> element.Element(mvu.Msg) {
  html.div([], [
    html.h2([], [html.text("Strategies")]),
    html.ul([], [
      html.li([], [
        html.p([], [
          html.text(
            "Honest 9 to 5: Never bet anything and rely solely on steady income.",
          ),
        ]),
      ]),
      html.li([], [html.p([], [html.text("Always bet 1k: always bet 1k")])]),
      html.li([], [
        html.p([], [
          html.text(
            "Slow and steady: aims to mitigate losses as much as possible. Bets the minimum amount (1k) at first. If it wins, bets 1k again. If it loses, tries to regain its losses by betting double, 2k. If it loses again, doubles its bet again to regain losses, betting 4k. etc. This way, steady gains are almost certain, but all is lost in case it gets many losses in a row.",
          ),
        ]),
      ]),
      html.li([], [html.p([], [html.text("Only all in: only all ins.")])]),
      html.li([], [
        html.p([], [
          html.text(
            "All in up to a point: Will all in until it reaches 10k points, after which it only bets 10k points every time.",
          ),
        ]),
      ]),
      html.li([], [
        html.p([], [
          html.text(
            "All in then quit: Always all in, until we reach 100k, then stop betting altogether.",
          ),
        ]),
      ]),
    ]),
  ])
}
