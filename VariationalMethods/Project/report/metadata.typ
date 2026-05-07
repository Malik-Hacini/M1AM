//-------------------------------------
// Document options
//

#let option = (
  type : none,
  lang : "en",
)
//-------------------------------------
// Optional generate titlepage image
//
// Helper function for unnumbered headers
#let nonumber(body) = {
  set heading(numbering: none)
  body
}


//-------------------------------------
// Metadata of the document
//
#let doc= (
  title    : [*Heat circulation modelling : Oven case study*],
  url      : "",
  logos: (
    tp_topleft  : image("assets/ensimag.png", width: 100pt),
    tp_topright : image("assets/im2ag.png", width: 100pt),
    tp_main     : none,
  ),
  authors: (
    (
      name        : "BOYER Timothé",
      abbr        : none,
      email       : "",
    ),

    (
      name        : "HACINI Malik",
      abbr        : none,
      email       : "",
    ),
 ),
  school: (
    name        : "ENSIMAG - UGA",
    major       : "M1AM",
  ),
  course: (
    name     : "Variational Methods applied to modelling",
    prof     : "Frédérique Charles and Clément Jourdana",
    semester : none,
  ),

  keywords : ("keyword1", "keyword2", "keyword3"),)

#let date= datetime.today()

//-------------------------------------
// Settings
//
#let tableof = (
  toc: false,
  tof: false,
  tot: false,
  tol: false,
  toe: false,
  maxdepth: 3,
)

#let gloss    = true
#let appendix = false
#let bib = (
  display : false,
  path  : "/tail/bibliography.bib",
  style : "ieee",
)
