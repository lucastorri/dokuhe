package main

import (
	"fmt"
	"io/ioutil"
	"math/rand"
	"net/http"
	"os"
	"regexp"
	"strconv"
	"time"
)

var helloService = os.Getenv("HELLO_SERVICE_URL")
var pagesService = os.Getenv("PAGES_SERVICE_URL")

func main() {
	rand.Seed(time.Now().Unix())

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		user := "user-" + strconv.Itoa(rand.Int())

		message := get(helloService + "?name=" + user)

		pageLinks := listAvailablePages()
		page := get(pageLinks[rand.Intn(len(pageLinks))])

		fmt.Fprintf(w, "<div></p>"+message+"</p><p>Here is an interesting fact:</p>"+page+"</div>")
	})

	http.ListenAndServe(":7000", nil)
}

func get(url string) (body string) {
	resp, err := http.Get(url)
	if err != nil {
		panic(err)
	}
	defer resp.Body.Close()
	bytes, err := ioutil.ReadAll(resp.Body)

	return string(bytes)
}

func listAvailablePages() (pageLinks []string) {
	body := get(pagesService)

	linkRegex := regexp.MustCompile("href=\"(.*)\"")

	for _, match := range linkRegex.FindAllStringSubmatch(string(body), -1) {
		pageLinks = append(pageLinks, pagesService+"/"+match[1])
	}

	return
}
