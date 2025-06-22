#import "@preview/oxifmt:0.2.1": strfmt

#let __question-number = counter("question-number")
#let __question-points = state("question-points", 0)
#let __total-points = state("total-points", 0)
#let __show-solution = state("show-solution", none)

#let __question-numbering(..args) = {
  let nums = args.pos()
  if (nums.len() == 1) {
    numbering("1. ", nums.last())
  }else if (nums.len() == 2) {
    numbering("(a) ", nums.last())
  }else if (nums.len() == 3) {
    numbering("(i) ", nums.last())
  }
}

#let __print-points(
  points: none
) = {
  if (points != none) {
    let label-point = "pontos"
    if points == 1 {
      label-point = "ponto"
    }
    [(#emph[#strfmt("{0}", calc.round(points, digits: 2), fmt-decimal-separator: ",") #label-point])]
  }
}

/// Cria uma questão.
/// 
/// *Exemplo:*
/// ```
/// #question(points: 2)[Com quantos paus fazem uma canoa?]
/// ```
/// 
/// - points (none, float, "auto", "last"): Pontos da questão.
/// - body (string, content): Corpo da questão.
/// -> content
#let question(
  points: none,
  body
) = {
  __question-number.step(level: 1)
  
  [#hide[]<end-of-question>]

  __question-points.update(0)

  v(1em)
  {
    context __question-number.display(__question-numbering)
    
    if (points == "auto"){
      context{
        let nextQuestion = query(selector(<end-of-question>).after(here())).first().location()
        __print-points(points: __question-points.at(nextQuestion))
        __total-points.update(p => p + __question-points.at(nextQuestion))
        h(0.2em)
      }
    }else if (points == "remaining"){
      context __print-points(points: 10 - __total-points.final())
      h(0.2em)
    }else if (points != none){
      __print-points(points: points)
      __total-points.update(p => p + points)
      h(0.2em)
    }
    body
  }
}

/// Cria um item de uma questão.
/// 
/// *Exemplo:*
/// ```
/// #subquestion(points: 0.5)[Com quantos paus fazem uma canoa?]
/// ```
/// 
/// - points (none, float): Pontos do item.
/// - body (string, content): Corpo do item.
/// -> content
#let subquestion(
  points: none,
  body
) = {
  __question-number.step(level: 2)

  set par(hanging-indent: 0.7em)

  v(0.1em)
  {
    h(0.7em)
    context __question-number.display(__question-numbering)
    
    let subquestion-points = if (points != none) {points} else {0}
    
    __question-points.update(p => p + subquestion-points)

    if (points != none) {
      __print-points(points: points)
      h(0.2em)
    }
    body
  }
}

#let solution(
    body,
  ) = {
  context {
    let show-solution = __show-solution.final()
    if (show-solution == "solution" and body != none){
      block(fill: luma(240), inset: 8pt, radius: 4pt, width: 100%)[#h(2em)*Solução:*
      
      #body
      ]
    }
  }
}

#let answer(
  body,
) = {
  context {
    let show-solution = __show-solution.final()
    if (show-solution == "answer" and body != none){
      [#h(2em)*Resposta:*#h(0.5em)#body]
    }
  }
}