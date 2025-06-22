#import "question.typ": question, subquestion, __show-solution, strfmt, solution, answer

/// Template para criar a avaliação.
///
/// \ 
/// **Exemplo**
/// ``` 
/// #show: ufac-exam.with()
/// ```
///  
///  \
/// 
/// - title (string, content): Título da avaliação (Ex.: Lista 1, Prova 1, Trabalho 1).
/// - subject (string, content): Disciplina da avaliação (Ex.:  Sinais e Sistemas).
/// - period (string, content): Período da avaliação (Ex.: 2024.2).
/// - professor (string, content): Nome do professor (Ex.: Lucas Lima Rodrigues).
/// - departament (string, content): Departamento da disciplina (Ex.: Centro de Ciências Exatas e Tecnológicas).
/// - course (string, content): Curso da disciplina (Ex.: Engenharia Elétrica).
/// - show-student-data (boolean): Mostra formulário para os dados do alunos.
/// - show-orientation-box (boolean): Mostra caixa de orientações.
/// - body (string, content): Corpo da avaliação.
/// -> content
#let ufac-exam(
  title: none,
  subject: none,
  period: none,
  professor: "Lucas Lima Rodrigues", 
  departament: "Centro de Ciências Exatas e Tecnológicas",
  course: "Engenharia Elétrica",
  show-student-data: true,
  show-orientation-box: true,
  show-solution: false,
  body,
) = {
  set page(
    paper: "a4",
    margin: (top: 3cm, left: 3cm, rest: 2cm),
  )
  set text(lang: "pt", font: "Tex Gyre Heros", size: 10pt)
  set par(justify: true)

  show heading: title => [
    #set align(center)
    #set text(size: 14pt, weight: "bold")
    #v(12pt)
    #block(upper(title))
    #v(20pt)
  ]
  __show-solution.update(show-solution)

  box(width: 100%)[
    #grid(rows: (auto, auto),
      grid(columns: (auto, auto), gutter: 0.7em,
        image("../assets/ufac.png", height: 2.5cm, width: 2.7cm, fit: "contain"),
        grid(rows: (auto, 12pt, 20pt), gutter: 1em,
          grid(columns: (auto, 1fr, auto), 
            align(left + top)[
              Universidade Federal do Acre \
              #departament \
              Curso de #course \
            ],
            align(center + top)[],align(right + top)[
              #subject \
              Prof. #professor \
              Período #period \
              #title \
            ],
          ),
          line(length: 100%, stroke: 1pt + gray),
        )
      ),
      if show-student-data {
        grid(gutter: 2.5em,
          grid(columns: (1fr, 4.5cm), gutter: 1em,
            align(left + bottom)[Nome: #box(width: 1fr, repeat[.])],
            align(left + bottom)[Matrícula: #box(width: 1fr, repeat[.])],
          ),
          grid(columns: (1fr, 4cm, 3cm), gutter: 1em, align: left + bottom,
            [],
            [Data: #box(width: 1fr, repeat[.]) / #box(width: 1fr, repeat[.]) / #box(width: 1.5fr, repeat[.])],
            [Nota: #box(width: 1fr, repeat[.])],
          )
        )
      }
    )  
  ]

  if (show-orientation-box){
    v(6pt)
  }
  if (show-student-data){
    v(6pt)
  }else{
    v(-24pt)
  }

  if show-orientation-box {
    rect(width: 100%, stroke: luma(120), inset: 12pt, radius: 4pt)[
      *Orientações gerais:*
      + Preencha seu nome e número de matrícula com *CANETA*.
      + A interpretação das questões é parte do processo de avalição, não sendo permitidas consultas ou comunicação entre os alunos.
      + A resposta final deve ser preenchida à *CANETA*.
    ]
  }

  body
}

#let num(number, round: 4) = {
  [#strfmt("{0}", calc.round(number, digits: round), fmt-decimal-separator: ",")]
}

#let Z-rect(Z, round: 4) = {
  let real_part = Z.at(0)
  let imag_part = Z.at(1)
  if imag_part == 0 and real_part != 0 {
    real_part = calc.round(real_part, digits: round)
    strfmt("{0}", real_part, fmt-decimal-separator: ",")
  }else if real_part == 0 and imag_part != 0 {
    imag_part = calc.round(imag_part, digits: round)
    if imag_part < 0 {
      imag_part = -imag_part
    }
    let signal = if imag_part < 0 { "-" } else { "" }
    strfmt("{0}j{1}", signal, imag_part, fmt-decimal-separator: ",")
  }else if real_part == 0 and imag_part == 0 {
    strfmt("0")
  }else if real_part != 0 and imag_part !=0 {
    let signal = if imag_part < 0 { "-" } else { "+" }
    real_part = calc.round(real_part, digits: round)
    imag_part = calc.round(imag_part, digits: round)
    if imag_part < 0 {
      imag_part = -imag_part
    }
    strfmt("{0}{1}j{2}", real_part, signal, imag_part, fmt-decimal-separator: ",")
  }
}

#let Z-polar(Z, round: 4) = {
  let m = calc.round(calc.norm(Z.at(0), Z.at(1)), digits: 4)
  let a = calc.round(calc.atan(Z.at(1)/Z.at(0)).deg(), digits: 4)
  [#strfmt("{0}∠{1}°", 
  m,
  a, 
  fmt-decimal-separator: ",")]
}

#let Z-angle-c(Z) = {
  return calc.atan(Z.at(1)/Z.at(0))
}

#let Z-angle(Z, round: 4) = {
  [#strfmt("{0}°", calc.round(calc.atan(Z.at(1)/Z.at(0)).deg(), digits: round), fmt-decimal-separator: ",")]
}

#let Z-abs-c(Z) = {
  return calc.norm(Z.at(0), Z.at(1))
}
#let Z-abs(Z, round: 4) = {
  [#strfmt("{0}", calc.round(calc.norm(Z.at(0), Z.at(1)), digits: 4), fmt-decimal-separator: ",")]
}


#let Z-add(c1, c2) = { c1.zip(c2).map(array.sum) }
#let Z-sub(c1, c2) = { c1.zip(c2).map(array.sub) }
#let Z-mul(c1, c2) = { (c1.at(0) * c2.at(0) - c1.at(1) * c2.at(1), c1.at(0) * c2.at(1) + c1.at(1) * c2.at(0))}
#let Z-div(c1, c2) = {
  (
    (c1.at(0) * c2.at(0) + c1.at(1) * c2.at(1)) / (c2.at(0) * c2.at(0) + c2.at(1) * c2.at(1)),
    (c1.at(1) * c2.at(0) - c1.at(0) * c2.at(1)) / (c2.at(0) * c2.at(0) + c2.at(1) * c2.at(1))
  )
}

#let Z-paralel(c1, c2) = {
  return Z-div(Z-mul(c1, c2), Z-add(c1, c2))
}
