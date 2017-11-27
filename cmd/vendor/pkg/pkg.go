package pkg

import (
	"io"
	"io/ioutil"
	"os"
	"path"
	"path/filepath"
	"strings"
	"text/template"

	"gopkg.in/yaml.v2"
)

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

type PackageCollection struct {
	Name     string
	Reviewed string
	List     []Package
}

type PackageSection struct {
	ID          string
	Description string
	Collections []PackageCollection
}

func (r *PackageSection) Render(w io.Writer) error {
	if err := r.handle(); err != nil {
		return err
	}
	if err := r.render(w); err != nil {
		return err
	}
	return nil
}

const tplPkg = `
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

> # shared:collection:{{ .ID }}
>
> {{ .Description }}.
{{ range .Collections }}
## {{ .Name }} {{ if eq .Reviewed "" }}(not reviewed yet){{ else }}(reviewed at {{ .Reviewed }}){{ end }}
{{- range .List }}{{ template "PACKAGE" . }}{{ end }}
{{ end }}

[![Analytics](https://ga-beacon.appspot.com/UA-109817251-4/shared/collection:{{ .ID }})](https://github.com/igrigorik/ga-beacon)
`

func (r *PackageSection) handle() error {
	m, err := filepath.Glob("./" + r.ID + "/*.yml")
	if err != nil {
		return err
	}

	r.Collections = make([]PackageCollection, 0, len(m))
	for _, file := range m {
		f, err := os.OpenFile(file, os.O_RDONLY, 0)
		if err != nil {
			return err
		}
		c, err := ioutil.ReadAll(f)
		f.Close()
		if err != nil {
			return err
		}
		var collection PackageCollection
		if err := yaml.Unmarshal(c, &collection); err != nil {
			return err
		}
		collection.Name = strings.TrimSuffix(path.Base(f.Name()), path.Ext(f.Name()))
		r.Collections = append(r.Collections, collection)
	}

	return nil
}

func (r *PackageSection) render(w io.Writer) error {
	tpl, err := template.New("readme").Parse(tplPkg)
	if err != nil {
		return err
	}
	return tpl.Execute(w, r)
}
