#import "lib.typ": *

#show: template.with(
  title: [PDEs and Numerical Methods],
  short_title: "PDEs",
  description:   [M1AM course at UGA, tutored by Eric Blayo.
  ],
  authors: (
    (
      name: "Malik Hacini",
    ),
  ),
  
  // lof: true,
  // lot: true,
  // lol: true,
  paper_size: "a4",
  // landscape: true,
  cols: 1,
  text_font: "STIX Two Text",
  math_font: "STIX Two Math",
  code_font: "Cascadia Mono",
  accent: "#1A41AC", // blue
  h1-prefix: "Exercise Sheet",
) 


= Introduction

#exercise[

+ $display(sum_(0)^(+infinity) 1/k^2 = pi^2/6)$
+ $display(integral_(0)^(+infinity) f(x) d x) product_(n=1)^(infinity)  $   
]
