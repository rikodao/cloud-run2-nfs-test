package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"time"
)


func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello World")
	}) // ハンドラを登録してウェブページを表示させる
	http.HandleFunc("/writetest", handler) // ハンドラを登録してウェブページを表示させる
	http.ListenAndServe(":8080", nil)

}
func getEnv(key, fallback string) string {
	if value, ok := os.LookupEnv(key); ok {
		return value
	}
	return fallback
}

func handler(write http.ResponseWriter, read *http.Request) {

	wfileName := getEnv("MNT_DIR",".") + "/write.txt"
	//
	w, err :=os.OpenFile(wfileName, os.O_RDWR|os.O_CREATE|os.O_APPEND, 0666)
	if err != nil {
		log.Fatal(err)
	}

	r, err := os.Open("./read.txt")
	if err != nil {
		log.Fatal(err)
	}

	start := time.Now()

	_, err = io.Copy(w, r)

	end := time.Now()
	time := (end.Sub(start)).Seconds()
	fmt.Printf("%f秒\n", time)

	if err != nil {
		log.Fatal(err)
	}
	fmt.Fprintf(write, "%f秒\n", time)

	_ = os.Remove(wfileName)
}