package main

import (
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"text/template"
)

type Section struct {
	ID          string
	Name        string
	Collections []Collection
}

type Collection struct {
	Name string
	List []Package
}

type Package struct {
	Name   string
	Src    string
	Tags   []string
	Used   bool
	Viewed bool
}

const tpl = `
> # shared:pmc-collection:{{ .ID }}
>
> My collection of useful {{ .Name }} packages.

{{ range .Collections }}
## {{ .Name }}

{{ range .List }}
- [{{ .Name }}]({{ .Src }})
  - [{{ if .Used }}x{{ else }} {{ end }}] used
  - [{{ if .Viewed }}x{{ else }} {{ end }}] viewed
{{ end }}
{{ end }}
`

var available = [...]string{"go", "javascript", "php", "python"}

func main() {
	defer func() {
		if r := recover(); r != nil {
			fmt.Println(r)
		} else {
			fmt.Println("success")
		}
	}()
	render(handle(parse()))
}

func parse() *Section {
	var (
		section, name string
	)

	fs := flag.NewFlagSet("build", flag.PanicOnError)
	fs.StringVar(&section, "s", "", "section (go, php, etc.)")
	fs.StringVar(&name, "n", "", "section name")
	fs.Parse(os.Args[1:])

	if sort.SearchStrings(available[:], section) == len(available) {
		panic(fmt.Sprintf("section %q not available", section))
	}

	return &Section{
		ID:   section,
		Name: name,
	}
}

func handle(s *Section) *Section {
	m, err := filepath.Glob("./" + s.ID + "/*.yml")
	if err != nil {
		panic(err)
	}
	fmt.Println(m)

	return s
}

func render(s *Section) *Section {
	template.Must(template.New("readme").Parse(tpl)).Execute(os.Stdout, s)
	return s
}
