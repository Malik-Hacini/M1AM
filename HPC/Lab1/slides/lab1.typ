#import "@preview/touying:0.5.5": *
#import "@preview/clean-math-presentation:0.1.1": *

#show: clean-math-presentation-theme.with(
  config-info(
    title: [High Perfomance Computing : Lab Session 1],
    authors: (
      (name: "Hacini Malik"),
    ),
    date: datetime(year: 2026, month: 02, day:04),
  ),
  config-common(
    slide-level: 3,
    //handout: true,
    //show-notes-on-second-screen: right,
  ),
  progress-bar: true,
)

#title-slide(

)

== Outline <touying:hidden>




#slide(title: "Matrix norm")[
  #figure(
    image("fig/1.png", width: 20%, height: auto),
    caption: [Performance comparison for $ norm(A)_1 =  max_(1 <=j <= n) sum_(i=1)^(n) a_(i j)$k, switching the loop order],
  ) <fimg-label>
]

#slide(title: "Matrix Matrix multiplication : loop order impact")[

      
      - Fastest: ikj / kij (~4.4–5.0 GFLOP/s at N≥512)
      - Slowest: jki / kji (~0.32–0.37 GFLOP/s at N≥512)
      - inner loop should stream contiguous memory
         ]

#slide(title: " Aliasing and Restrict statements")[

      - restricted_ikj ≈ 6.66 GFLOP/s at N=1024
      - simple_ikj ≈ 4.46 GFLOP/s at N=1024
      - Reason: restrict removes aliasing constraints

]
