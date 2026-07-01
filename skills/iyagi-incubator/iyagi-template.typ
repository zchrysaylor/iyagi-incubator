// iyagi-template.typ
// Self-contained Korean-language-learning short-story one-pager.
// Visual direction: "Editorial serif magazine" — warm, elegant, book-like.
// Colored section headers (boxed-sheet feel) cycling through a muted palette.
// Fonts: Libertinus Serif + NanumMyeongjo (body), NanumGothic (headers/UI).
// No external packages. Typst 0.15.0.
//
// Public API — call from an instance file:
//   #import "iyagi-template.typ": iyagi-sheet
//   #iyagi-sheet(
//     topic: "first love",        // str
//     level: "2A",                // str
//     grammar-count: 6,            // int
//     korean: [ … ],               // content (paragraphs split by a blank line)
//     english: [ … ] | none,       // content or none -> omits the section
//     grammar: ((formula: "…", sentence: "…", meaning: "…"), …),
//     vocab: (("한국어", "english"), …) | none,
//     questions: ([ … ], …) | none,
//   )
// See example.typ for a full worked instance. Internal helpers use the `ii-`
// (iyagi-incubator) prefix; only `iyagi-sheet` is meant to be called.

// ---- Palette (muted editorial tones) ----
#let ii-ink      = rgb("#2b2622")   // warm near-black body ink
#let ii-paper    = rgb("#fbf8f3")   // warm ivory page
#let ii-muted    = rgb("#8a7f74")   // muted brown-grey for sub-labels

// Section palette (header bar fill), cycled by section order.
#let ii-palette = (
  rgb("#b0562e"),  // terracotta
  rgb("#c08a2e"),  // ochre / mustard
  rgb("#2f7d76"),  // teal
  rgb("#a85668"),  // dusty rose
  rgb("#6e5285"),  // plum
  rgb("#5e7a52"),  // sage
)

// A very light tint of a color, for content-box background & zebra rows.
#let ii-tint(c, amount) = c.lighten(amount)

// ---- Section block with colored header ----
// Renders a slim full-width colored header bar with a small rounded left
// accent, white bold sans label + faint Korean sub-label, over a tinted,
// hairline-bordered content box.
// `pad-bottom` adds extra space to the bottom of the content box; used to
// equalize the height of side-by-side sections (see the two-up layout below).
#let ii-section(color, label-en, label-ko, body, pad-bottom: 0pt) = {
  block(
    width: 100%,
    breakable: false,
    inset: 0pt,
    {
      // Header bar
      block(
        width: 100%,
        fill: color,
        radius: (top-left: 4pt, top-right: 4pt),
        inset: (x: 12pt, y: 5pt),
        {
          grid(
            // English label flexes; Korean sub-label takes its natural width
            // (auto) so it never wraps in a narrow two-up column.
            columns: (1fr, auto),
            align: (left + horizon, right + horizon),
            column-gutter: 8pt,
            // left accent tick + English label
            box({
              box(baseline: 0.15em, rect(
                width: 3pt, height: 0.95em,
                fill: white.transparentize(35%),
                radius: 2pt,
              ))
              h(7pt)
              text(
                font: "NanumGothic",
                size: 10pt,
                weight: "bold",
                fill: white,
                tracking: 0.3pt,
                upper(label-en),
              )
            }),
            // faint Korean sub-label, right aligned — natural width, no wrap
            text(
              font: "NanumGothic",
              size: 9pt,
              weight: "regular",
              fill: white.transparentize(22%),
              label-ko,
            ),
          )
        },
      )
      // Content box. `above` is half the default 0.85em paragraph spacing,
      // to keep the gap between the header bar and the box tight.
      block(
        width: 100%,
        above: 0.425em,
        fill: ii-tint(color, 93%),
        stroke: 0.6pt + ii-tint(color, 45%),
        radius: (bottom-left: 4pt, bottom-right: 4pt),
        inset: (left: 12pt, right: 12pt, top: 8pt, bottom: 8pt + pad-bottom),
        body,
      )
    },
  )
}

// ---- Small pill badge (masthead) ----
#let ii-badge(color, key, val) = box(
  fill: ii-tint(color, 88%),
  stroke: 0.7pt + ii-tint(color, 40%),
  radius: 20pt,
  inset: (x: 11pt, y: 5pt),
  baseline: 0.32em,
  {
    text(font: "NanumGothic", size: 7.6pt, weight: "bold",
      fill: color.darken(12%), tracking: 0.5pt, upper(key))
    h(5pt)
    text(font: "NanumGothic", size: 9pt, weight: "bold", fill: ii-ink, val)
  },
)

// ---- Main template function ----
#let iyagi-sheet(
  topic: "",
  level: "",
  grammar-count: 0,
  korean: [],
  english: none,
  grammar: (),
  vocab: none,
  questions: none,
) = {
  set page(
    paper: "a4",
    margin: (x: 1.7cm, top: 1.15cm, bottom: 1.15cm),
    fill: ii-paper,
  )
  set text(
    font: ("Libertinus Serif", "NanumMyeongjo"),
    size: 10.5pt,
    fill: ii-ink,
    lang: "en",
  )
  set par(justify: true, leading: 0.7em, spacing: 0.85em)

  // running counter for palette cycling across the used sections.
  // (Typst closures can't mutate outer bindings, so we track the index
  //  in the main body and shadow-rebind it on each use.)
  let sec-i = 0
  let color-at(i) = ii-palette.at(calc.rem(i, ii-palette.len()))

  // ---------- Masthead ----------
  block(width: 100%, {
    text(font: "NanumGothic", size: 8pt, weight: "bold",
      fill: ii-muted, tracking: 2.5pt, upper("Korean Reader · 한국어 이야기"))
    v(3pt)
    text(font: "Libertinus Serif", size: 22pt, weight: "bold",
      fill: ii-ink, style: "italic", topic)
    v(6pt)
    ii-badge(ii-palette.at(0), "Level", level)
    h(7pt)
    ii-badge(ii-palette.at(2), "Grammar", str(grammar-count) + " patterns")
  })
  v(6pt)
  line(length: 100%, stroke: 0.8pt + ii-tint(ii-ink, 55%))
  v(8pt)

  // ---------- 1. Korean Story ----------
  ii-section(color-at(sec-i), "Korean Story", "한국어 이야기", {
    set text(size: 10.5pt)
    set par(leading: 0.72em, spacing: 0.66em, first-line-indent: 0pt)
    korean
  })
  sec-i += 1
  v(6pt)

  // ---------- 2. English Translation (omittable) ----------
  if english != none {
    ii-section(color-at(sec-i), "English Translation", "영어 번역", {
      set text(size: 9.5pt, fill: ii-tint(ii-ink, 8%))
      set par(leading: 0.66em, spacing: 0.66em)
      english
    })
    sec-i += 1
    v(6pt)
  }

  // ---------- 3. Target Grammar (3-column table) ----------
  if grammar != none and grammar.len() > 0 {
    let g-color = color-at(sec-i)
    sec-i += 1
    ii-section(g-color, "Target Grammar", "핵심 문법", {
      set par(justify: false)
      // Hollow header: no fill, label in the section color, over a strong
      // bottom rule — so it reads as a table header, not a second banner.
      let header(t) = table.cell(
        inset: (x: 8pt, y: 6pt),
        align: bottom + left,
        text(font: "NanumGothic", size: 8pt, weight: "bold",
          fill: g-color.darken(8%), tracking: 0.6pt, upper(t)),
      )
      table(
        columns: (auto, 1fr, auto),
        stroke: none,
        inset: (x: 8pt, y: 5pt),
        align: (left + horizon, left + horizon, left + horizon),
        fill: (_, row) => if row == 0 { none }
          else if calc.odd(row) { ii-tint(g-color, 96%) }
          else { white.transparentize(40%) },
        header("Formula"),
        header("Sentence"),
        header("Meaning"),
        table.hline(y: 1, stroke: 1.4pt + g-color),
        ..grammar.map(g => (
          text(font: "NanumGothic", size: 9.5pt, weight: "bold",
            fill: g-color.darken(15%), g.formula),
          text(size: 9.5pt, g.sentence),
          text(size: 9pt, fill: ii-tint(ii-ink, 12%), style: "italic", g.meaning),
        )).flatten(),
      )
    })
    v(6pt)
  }

  // ---------- 4 & 5. Vocabulary + Practice ----------
  // Both are compact reference sections. When both are present they sit
  // side-by-side (magazine two-up) to conserve vertical space; either can
  // stand alone full-width when the other is omitted.
  let has-vocab = vocab != none and vocab.len() > 0
  let has-q = questions != none and questions.len() > 0

  // Vocabulary as reusable content. `cols` = number of internal term columns.
  // `pad` adds bottom padding so the box can be height-matched to a neighbour.
  let vocab-block(v-color, cols, pad: 0pt) = ii-section(
    v-color, "Useful Vocabulary", "유용한 어휘",
    {
      set par(justify: false)
      let vtable(rows) = table(
        columns: (auto, 1fr),
        stroke: none,
        inset: (x: 8pt, y: 4.5pt),
        align: (left + horizon, left + horizon),
        fill: (_, row) => if calc.even(row) { ii-tint(v-color, 96%) }
          else { white.transparentize(40%) },
        ..rows.map(p => (
          text(size: 9.5pt, weight: "bold", fill: v-color.darken(12%), p.at(0)),
          text(size: 9pt, fill: ii-tint(ii-ink, 12%), p.at(1)),
        )).flatten(),
      )
      if cols <= 1 {
        vtable(vocab)
      } else {
        let half = calc.ceil(vocab.len() / 2)
        grid(
          columns: (1fr, 1fr),
          column-gutter: 12pt,
          vtable(vocab.slice(0, half)),
          vtable(vocab.slice(half)),
        )
      }
    },
    pad-bottom: pad,
  )

  // Practice as reusable content. `label-en` lets the two-up (narrow) form
  // use a shorter English label so the bilingual header stays on one line.
  // `pad` adds bottom padding so the box can be height-matched to a neighbour.
  let practice-block(q-color, label-en, pad: 0pt) = ii-section(
    q-color, label-en, "연습 문제",
    {
      set par(justify: false, leading: 0.72em, spacing: 0.58em)
      for (i, q) in questions.enumerate() {
        grid(
          columns: (auto, 1fr),
          column-gutter: 8pt,
          align: (right + top, left + top),
          box(
            fill: q-color,
            radius: 50%,
            width: 15pt, height: 15pt,
            align(center + horizon,
              text(font: "NanumGothic", size: 8pt, weight: "bold",
                fill: white, str(i + 1))),
          ),
          box(inset: (top: 1pt), text(size: 9.5pt, q)),
        )
        if i < questions.len() - 1 { v(3.5pt) }
      }
    },
    pad-bottom: pad,
  )

  if has-vocab and has-q {
    // Two-up: wide vocabulary (two internal term columns) beside the practice
    // questions. Their natural heights differ, so measure both at their real
    // column widths and pad the shorter box's bottom to equalize the heights.
    let v-color = color-at(sec-i)
    let q-color = color-at(sec-i + 1)
    sec-i += 2
    let gutter = 10pt
    layout(size => {
      let avail = size.width - gutter
      let w-v = avail * 1.5 / 2.5
      let w-q = avail * 1.0 / 2.5
      context {
        let h-v = measure(box(width: w-v, vocab-block(v-color, 2))).height
        let h-q = measure(box(width: w-q, practice-block(q-color, "Practice"))).height
        let mh = calc.max(h-v, h-q)
        grid(
          columns: (1.5fr, 1fr),
          column-gutter: gutter,
          align: (top, top),
          vocab-block(v-color, 2, pad: mh - h-v),         // wide -> two term columns
          practice-block(q-color, "Practice", pad: mh - h-q),  // narrow -> short label
        )
      }
    })
  } else if has-vocab {
    let v-color = color-at(sec-i)
    sec-i += 1
    vocab-block(v-color, 2)
  } else if has-q {
    let q-color = color-at(sec-i)
    sec-i += 1
    practice-block(q-color, "Practice Questions")
  }
}
