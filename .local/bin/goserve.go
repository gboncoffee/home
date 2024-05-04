package main

import "net/http"

func main() {
	port := ":6969"
	handler := http.FileServer(http.Dir("."))
	http.ListenAndServe(port, handler)
}
