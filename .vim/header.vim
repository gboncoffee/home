vim9script

var cursor = line('.')

append(cursor,     "author Gabriel G. de Brito gabrielgbrito@icloud.com")
append(cursor + 1, "version 0.0.0")
append(cursor + 2, "since ")
append(cursor + 3, "")

normal 3j$
r ! date +'\%b \%d, \%Y'
normal kJj0
