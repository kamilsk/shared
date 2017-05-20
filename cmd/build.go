package main

import (
	"bytes"
	"flag"
	"fmt"
	"io"
	"io/ioutil"
	"os"
	"path"
	"path/filepath"
	"sort"
	"strings"
	"text/template"

	"gopkg.in/yaml.v2"
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
	Name        string
	Src         string
	Site        string
	Description string

	Tags []string

	Used   bool
	Viewed bool

	Alternative []Package
	Related     []Package
	Useful      []Package
}

const tpl = `
{{- define "PACKAGE" }}

- [{{ .Name }}]({{ .Src }}) {{- if .Site }}, [site]({{ .Site }}){{ end }}
  - [{{ if .Used   }}x{{ else }} {{ end }}] used
  - [{{ if .Viewed }}x{{ else }} {{ end }}] viewed

{{- if .Alternative }}{{ template "ALTERNATIVE" . }}{{ end }}
{{- if .Related     }}{{ template "RELATED" . }}{{ end }}
{{- if .Useful      }}{{ template "USEFUL" . }}{{ end }}

{{- end -}}

{{- define "ALTERNATIVE" }}

  - Alternatives:
{{ range .Alternative }}
    - [{{ .Name }}]({{ .Src }}) {{- if .Site }}, [site]({{ .Site }}){{ end }}
      - [{{ if .Used   }}x{{ else }} {{ end }}] used
      - [{{ if .Viewed }}x{{ else }} {{ end }}] viewed
{{- end }}
{{- end -}}

{{- define "RELATED" }}

  - Related:
{{ range .Related }}
    - [{{ .Name }}]({{ .Src }}) {{- if .Site }}, [site]({{ .Site }}){{ end }}
      - [{{ if .Used   }}x{{ else }} {{ end }}] used
      - [{{ if .Viewed }}x{{ else }} {{ end }}] viewed
{{- end }}
{{- end -}}

{{- define "USEFUL" }}

  - Useful:
{{ range .Useful }}
    - [{{ .Name }}]({{ .Src }}) {{- if .Site }}, [site]({{ .Site }}){{ end }}
      - [{{ if .Used   }}x{{ else }} {{ end }}] used
      - [{{ if .Viewed }}x{{ else }} {{ end }}] viewed
{{- end }}
{{- end -}}

> # shared:pmc-collection:{{ .ID }}
>
> My collection of useful {{ .Name }} packages.
{{ range .Collections }}
## {{ .Name }}
{{- range .List }}{{ template "PACKAGE" . }}{{ end }}
{{ end -}}`

var available = [...]string{"go", "javascript", "php", "python"}

func main() {
	defer func() {
		if r := recover(); r != nil {
			fmt.Println(r)
		} else {
			fmt.Println("success")
		}
	}()
	buf := bytes.NewBuffer(make([]byte, 0, 5*1024))
	flush(buf, render(buf, handle(parse())))
}

func flush(r io.Reader, s *Section) *Section {
	file, err := os.OpenFile("./"+s.ID+"/README.md", os.O_WRONLY|os.O_CREATE|os.O_TRUNC, os.FileMode(0644))
	if err != nil {
		panic(err)
	}

	data, err := ioutil.ReadAll(r)
	if err != nil {
		panic(err)
	}

	file.Write(data)

	return s
}

func handle(s *Section) *Section {
	m, err := filepath.Glob("./" + s.ID + "/*.yml")
	if err != nil {
		panic(err)
	}

	s.Collections = make([]Collection, 0, len(m))
	for _, file := range m {
		f, err := os.OpenFile(file, os.O_RDONLY, 0)
		if err != nil {
			panic(err)
		}
		c, err := ioutil.ReadAll(f)
		f.Close()
		if err != nil {
			panic(err)
		}
		var collection Collection
		if err := yaml.Unmarshal(c, &collection); err != nil {
			panic(err)
		}
		collection.Name = strings.TrimSuffix(path.Base(f.Name()), path.Ext(f.Name()))
		s.Collections = append(s.Collections, collection)
	}

	return s
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

func render(w io.Writer, s *Section) *Section {
	template.Must(template.New("readme").Parse(tpl)).Execute(w, s)

	return s
}
