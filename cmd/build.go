package main

import (
	"flag"
	"os"
)

type Package struct {
	Name   string
	Src    string
	Tags   []string
	Used   bool
	Viewed bool
}

const template = `
> # shared:pmc-collection:%section%
>
> %description%.

%content%
`

var available = [...]string{"go", "javascript", "php", "python"}

func main() {
	var (
		section, name, desc string
	)
	fs := flag.NewFlagSet("build", flag.PanicOnError)
	fs.StringVar(&section, "s", "", "section (go, php, etc.)")
	fs.StringVar(&name, "n", "", "section name")
	fs.StringVar(&desc, "d", "", "section description")
	fs.Parse(os.Args[1:])
}
