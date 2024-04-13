//go:build ignore

// This script embeds shell files into Go code, enabling their usage after the build process within the resulting binary/executable file. Run 'go generate' to create the necessary files.
package main

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"golang.org/x/text/cases"
	"golang.org/x/text/language"
)

func main() {
	scriptsDir := "cmd/sh"
	outputDir := "embedded"

	if err := os.MkdirAll(outputDir, 0755); err != nil {
		fmt.Println("Error creating output directory:", err)
		os.Exit(1)
	}

	scripts, err := os.ReadDir(scriptsDir)
	if err != nil {
		fmt.Println("Error reading scripts directory:", err)
		os.Exit(1)
	}

	for _, scriptInfo := range scripts {
		if scriptInfo.IsDir() {
			continue
		}

		scriptPath := filepath.Join(scriptsDir, scriptInfo.Name())
		content, err := os.ReadFile(scriptPath)
		if err != nil {
			fmt.Printf("Error reading script %s: %v\n", scriptInfo.Name(), err)
			continue
		}
		caser := cases.Title(language.English)
		outputFilename := caser.String(strings.TrimSuffix(scriptInfo.Name(), filepath.Ext(scriptInfo.Name())) + ".go")
		outputFilePath := filepath.Join(outputDir, outputFilename)
		if err := os.WriteFile(
			outputFilePath,
			[]byte(fmt.Sprintf("package embedded\n\nimport (\n \"fmt\"\n  \"log\"\n  \"os\"\n  \"os/exec\"\n)\n\nfunc %sScript(name string, path string){\nsh := fmt.Sprintf(`%s`, name, path) \nrunner := exec.Command(\"/bin/bash\", \"-c\", sh)\nrunner.Stdout = os.Stdout\nrunner.Stderr = os.Stderr\nif err := runner.Run(); err != nil {\nlog.Fatalln(\"ERROR CREATING THE PROJECT\", err)\n}\n}", strings.Trim(outputFilename, ".go"), content)), 0644); err != nil {
			fmt.Printf("Error writing embedded file %s: %v\n", outputFilename, err)
			continue
		}
	}
}
