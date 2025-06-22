#import "@local/ufac-exam:0.0.1": *

#show: ufac-exam.with(
  subject: "CCETXXX - Disciplina",
  title: "Prova 1",
  period: "202X.X",
  professor: "Professor Fulano de Tal",
  show-orientation-box: false,
  show-student-data: false,
  show-solution: "solution",
)

= Questões

// Calcula a quantidade de pontos automaticamente (Soma a quantidade de pontos de todas as questões).
#question(points: "auto")[Responda as seguintes perguntas:]

#subquestion(points: 0.5)[Quanto é 2 + 2?]
#subquestion(points: 2)[Quanto é 3 + 3?]

// Define um valor de pontos fixo para a questão.
#question(points: 2)[Explique o que é a Universidade Federal do Acre.]

// Define uma questão sem pontos (Útil para listas).
#question[Essa questão não tem pontos, mas é importante!]

// Define uma questão com uma pontuação fixa.
#question(points: 3)[
  Explique o que é a Universidade Federal do Acre.
]

// Mostra a solução da questão. Tem que tá com a opção `show-solution` habilitada com o valor `"solution"`.
#solution[
A Universidade Federal do Acre é uma instituição de ensino superior pública localizada no estado do Acre, Brasil.
]

// Define a pontuação da questão como a quantidade de pontos restantes para completar a prova.
#question(points: "remaining")[Quantos pontos faltam para completar a prova?]

= Fórmulas

$
  integral_0^(10)x d x
$

$
z = x+y
$