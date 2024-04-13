package cmd

import (
	"charlinchui/byfa/embedded"
	"log"
	"os"
	"strings"

	"github.com/spf13/cobra"
)

var express = &cobra.Command{
	Use:   "express",
	Short: "A command to scaffold an express api",
	Long: `A command to scaffold the base project for an express API.
	Usage: byfa express -n <api-name> -l <location [default="."]>
	Example: byfa express -n my-super-awesome-api -l . --> Creates the base express project for an api named my-super-awesome-api at the current location.
	Requires: node&npm installed.
	`,
	Run: func(cmd *cobra.Command, args []string) {
		name, _ := cmd.Flags().GetString("name")
		location, _ := cmd.Flags().GetString("location")
		path, err := os.Getwd()
		if err != nil {
			log.Fatal("ERROR GETTING WORK DIRECTORY ->", err)
		}
		if location[0] == '.' {
			location = strings.Replace(location, "./", "", -1)
			location = strings.Replace(location, ".", "", -1)
		}
		path = path + "/" + location
		embedded.ExpressScript(name, path)
	},
}

func init() {
	express.Flags().StringP("name", "n", "", "Name for the project")
	express.Flags().StringP("location", "l", ".", "Location where to build the API")
	rootCmd.AddCommand(express)
}
