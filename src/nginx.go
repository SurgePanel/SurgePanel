package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"strings"
)

func main() {

	nginxConfPath := "/etc/nginx/nginx.conf"

	newInclude := "include /home/surgepanel/sites-configured/*.conf;"

	data, err := ioutil.ReadFile(nginxConfPath)
	if err != nil {
		fmt.Printf("Error reading nginx.conf: %v\n", err)
		return
	}
git 
	confContent := string(data)

	if strings.Contains(confContent, newInclude) {
		fmt.Println("The include directive already exists in nginx.conf.")
		return
	}

	confContent = strings.TrimSpace(confContent)
	if strings.HasSuffix(confContent, "}") {
		confContent = strings.TrimSuffix(confContent, "}") + "\n    " + newInclude + "\n}"
	} else {
		confContent += "\n" + newInclude
	}

	err = ioutil.WriteFile(nginxConfPath, []byte(confContent), 0644)
	if err != nil {
		fmt.Printf("Error writing to nginx.conf: %v\n", err)
		return
	}

	fmt.Println("Successfully added the include directive to nginx.conf.")
}
