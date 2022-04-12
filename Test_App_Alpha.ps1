Function test_app {
    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

    $path = "C:\temp\Homework\string_test.txt"
    
    

    # Draw Form
    $Test_Form = New-Object System.Windows.Forms.Form
    $Test_Form.Text = "Test_App"
    $Test_Form.ClientSize = New-Object System.Drawing.Size(600, 500)
    $Test_Form.BackColor = "LightGray"
    $Test_Form.StartPosition = "CenterScreen"
    $StopScript = $Script:CANCELED=$True

    #This creates a Dropdownbox
    $searchhistory = New-Object System.Windows.Forms.Combobox 
    $searchhistory.Location = New-Object System.Drawing.Size(10,30) 
    $searchhistory.Size = New-Object System.Drawing.Size(160,20)
    $searchhistory.Height = 200
    $searchhistory.TabIndex = 0 
    $Test_Form.Controls.Add($searchhistory)


    #checks for file containing search history
    [System.Boolean]$ExecuteFileCheck = {

    If (Test-Path -Path "C:\temp\Homework" -PathType Container -IsValid) {
    
        If (Test-Path -Path "C:\temp\Homework\string_test.txt" -PathType Leaf -IsValid) {

            $path = "C:\temp\Homework\string_test.txt"

            return $true
    
        }
    
        Else {
    
            New-item -Path "C:\temp\Homework" -Name "string_test.txt" -ItemType "file" -Force
    
            $path = "C:\temp\Homework\string_test.txt"

            return $true
    
        }

    }
    else {

        New-item -Path "C:\temp" -Name "Homework" -ItemType "directory" -Force

        New-item -Path "C:\temp\Homework" -Name "string_test.txt" -ItemType "file" -Force
    
        $path = "C:\temp\Homework\string_test.txt"

        return $true

        }

    }

    
    #Need to clean up this block#############################################
    If ($ExecuteFileCheck) {
    
        Write-Host "Check for search history..."

        [string[]]$arrayFromFile = Get-Content -Path $path

        foreach ($item in [string[]]$arrayFromFile) {

            $searchhistory.Items.Add($item)

        }
    }

    else {

        Write-Host "Something went wrong with ExecuteFileCheck..."

    }


    #############################################################################

    #This creates a custom search box
    $customsearch = New-Object System.Windows.Forms.Textbox 
    $customsearch.Location = New-Object System.Drawing.Size(425,30) 
    $customsearch.Size = New-Object System.Drawing.Size(160,20)
    $customsearch.Height = 200
    $customsearch.TabIndex = 0 
    $Test_Form.Controls.Add($customsearch)

    #This creates a output box
    $obj_output_box = New-Object System.Windows.Forms.TextBox 
    $obj_output_box.Location = New-Object System.Drawing.Size(10,60) 
    $obj_output_box.Size = New-Object System.Drawing.Size(580,425)
    $obj_output_box.Multiline = $True
    $obj_output_box.ScrollBars = "Vertical"
    $obj_output_box.TabIndex = 0 
    $Test_Form.Controls.Add($obj_output_box)
    
    # Search Button
    $Search_Button = New-Object System.Windows.Forms.Button
    $Search_Button.Location = New-Object System.Drawing.Point(175,29)
    $Search_Button.Size = New-Object System.Drawing.Size(98,23)
    $Search_Button.BackColor = "LightGray"
    $Search_Button.Text = "Search"
    $Search_Button.Add_Click({ 
            
            $obj_output_box.Text = ""

            if(($searchhistory.SelectedIndex -gt -1) -and ($customsearch.Text -ne $null)){
            
                [System.String]$selection = $searchhistory.SelectedItem.ToString()


                $w = Invoke-WebRequest -Uri "https://en.wikipedia.org/wiki/$selection"


                $data = $w.AllElements | where tagname -EQ "p" | Select innerText | Out-String


                $obj_output_box.Text = $data
                
            }
            
            else{

                $uinput = $customsearch.Text

                Add-Content -Path $path -Value $uinput

                $wc = Invoke-WebRequest -Uri "https://en.wikipedia.org/wiki/$uinput"

                $obj_output_box.Text =$wc.AllElements | where tagname -EQ "p" | Select innerText | Out-String

                Return
                
            }
        
        
      })
    $Test_Form.Controls.Add($Search_Button)

    # Render Form
    $Test_Form.Add_Shown({$Test_Form.Activate()})
    $Test_Form.ShowDialog() | Out-Null
    $Test_Form.Dispose() | Out-Null




}
test_app


#Format search strings to remove spaces after saved to $arrayFromFile but before added to $wc so the user can use spaces and still look clean in dropdown.

#stop blank string from saving to $arrayFromFile when search history is used instead of custom search.

#output custom string name at the top of $obj_output_box.Text

#Refresh application or or possibly just dropdown box to reflect up to date search results without closing

#delete string from custom search box once user clicks the button