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

---

    Code
      print_percent(list(a = 0.52366, b = 0.23456, c = "test"))
    Output
      $a
      [1] "52.4%"
      
      $b
      [1] "23.5%"
      
      $c
      [1] "test"
      

---

    Code
      print_percent(list(a = 0.52366, b = 0.23456, c = "test", d = list(a = 0.52366,
        b = 0.23456, c = "test")), accuracy = 0.01)
    Output
      $a
      [1] "52.37%"
      
      $b
      [1] "23.46%"
      
      $c
      [1] "test"
      
      $d
      $d$a
      [1] "52.37%"
      
      $d$b
      [1] "23.46%"
      
      $d$c
      [1] "test"
      
      

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

---

    Code
      print_currency(list(a = 234, b = 1234567.123456, c = "test"))
    Output
      $a
      [1] "234"
      
      $b
      [1] "1,234,567"
      
      $c
      [1] "test"
      

---

    Code
      print_currency(list(a = 234, b = 1234567.123456, c = "test", d = list(a = 234,
        b = 1234567.123456, c = "test")), accuracy = 0.01)
    Output
      $a
      [1] "234.00"
      
      $b
      [1] "1,234,567.12"
      
      $c
      [1] "test"
      
      $d
      $d$a
      [1] "234.00"
      
      $d$b
      [1] "1,234,567.12"
      
      $d$c
      [1] "test"
      
      

