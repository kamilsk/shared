package pkg

import (
	"io"
	"io/ioutil"
	"os"
	"sort"
	"strings"
	"text/template"

	"gopkg.in/yaml.v2"
)

type Awesome struct {
	Name string
	Src  string
	Site string
}

type AwesomeList []Awesome

func (l AwesomeList) Len() int {
	return len(l)
}

func (l AwesomeList) Less(i, j int) bool {
	return strings.Compare(strings.ToLower(l[i].Name), strings.ToLower(l[j].Name)) == -1
}

func (l AwesomeList) Swap(i, j int) {
	l[i], l[j] = l[j], l[i]
}

func (l AwesomeList) SortByName() {
	sort.Sort(l)
}

type AwesomeSection struct {
	List AwesomeList
}

func (r *AwesomeSection) Render(w io.Writer) error {
	if err := r.handle(); err != nil {
		return err
	}
	r.List.SortByName()
	if err := r.render(w); err != nil {
		return err
	}
	return nil
}

const tplAwsm = `
{{- define "ITEM" }}
### [{{ .Name }}]({{ .Src }}) {{- if .Site }}, [site]({{ .Site }}){{ end }}
{{ end -}}

> # shared:collection:awesome
>
> Collection of collections for indexing.
{{ range .List }}{{ template "ITEM" . }}{{ end }}

[![Analytics](https://ga-beacon.appspot.com/UA-109817251-4/shared/collection:awesome)](https://github.com/igrigorik/ga-beacon)
`

func (r *AwesomeSection) handle() error {
	f, err := os.OpenFile("./awesome/list.yml", os.O_RDONLY, 0)
	if err != nil {
		return err
	}
	c, err := ioutil.ReadAll(f)
	f.Close()
	if err != nil {
		return err
	}
	if err := yaml.Unmarshal(c, r); err != nil {
		return err
	}
	return nil
}

func (r *AwesomeSection) render(w io.Writer) error {
	tpl, err := template.New("readme").Parse(tplAwsm)
	if err != nil {
		return err
	}
	return tpl.Execute(w, r)
}
