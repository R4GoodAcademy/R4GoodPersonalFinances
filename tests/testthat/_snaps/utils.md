# printing percent

    Code
      print_percent(0.52366)
    Output
      [1] "52.4%"

---

    Code
      print_percent(0.52366, accuracy = 0.01)
    Output
      [1] "52.37%"

# printing currency

    Code
      print_currency(234)
    Output
      [1] "234"

---

    Code
      print_currency(234, prefix = "$")
    Output
      [1] "$234"

---

    Code
      print_currency(234, suffix = " PLN")
    Output
      [1] "234 PLN"

---

    Code
      print_currency(1234567.123456)
    Output
      [1] "1,234,567"

---

    Code
      print_currency(1234567.123456, accuracy = 0.01)
    Output
      [1] "1,234,567.12"

