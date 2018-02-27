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
> [![Analytics](https://ga-beacon.appspot.com/UA-109817251-4/shared/collection:awesome?pixel)](https://github.com/kamilsk/shared/tree/collection)
> Collection of collections for indexing.

[![Patreon](https://img.shields.io/badge/patreon-donate-orange.svg)](https://www.patreon.com/octolab)

{{ range .List }}{{ template "ITEM" . }}{{ end }}

---

[![@kamilsk](https://img.shields.io/badge/author-%40kamilsk-blue.svg)](https://twitter.com/ikamilsk)
[![@octolab](https://img.shields.io/badge/sponsor-%40octolab-blue.svg)](https://twitter.com/octolab_inc)

made with ❤️ by [OctoLab](https://www.octolab.org/)
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
