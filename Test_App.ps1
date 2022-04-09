﻿Function test_app {
    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")


    

    Function wiki_search {

    $selection = $obj_search_box.SelectedItem.ToString()
    

        if($selection -eq "Batman"){

            $wb = Invoke-WebRequest -Uri "https://en.wikipedia.org/wiki/Batman"
            $obj_output_box.Text =$wb.AllElements | where tagname -EQ "P" | Select innerText | Out-String

        }
        elseif($selection -eq "Superman"){

         $ws = Invoke-WebRequest -Uri "https://en.wikipedia.org/wiki/Superman"
            $obj_output_box.Text =$ws.AllElements | where tagname -EQ "P" | Select innerText | Out-String

        }
        elseif($selection -eq "Flash"){

        $wf = Invoke-WebRequest -Uri "https://en.wikipedia.org/wiki/TheFlash"
            $obj_output_box.Text =$wf.AllElements | where tagname -EQ "P" | Select innerText | Out-String

        }

    }

    # Draw Form
    $Test_Form = New-Object System.Windows.Forms.Form
    $Test_Form.Text = "Test_App"
    $Test_Form.ClientSize = New-Object System.Drawing.Size(600, 500)
    $Test_Form.BackColor = "LightGray"
    $Test_Form.StartPosition = "CenterScreen"
    $StopScript = $Script:CANCELED=$True

    #This creates a Dropdownbox
    $obj_search_box = New-Object System.Windows.Forms.Combobox 
    $obj_search_box.Location = New-Object System.Drawing.Size(10,30) 
    $obj_search_box.Size = New-Object System.Drawing.Size(160,20)
    $obj_search_box.Height = 200
    $obj_search_box.TabIndex = 0 
    $Test_Form.Controls.Add($obj_search_box)

    [array]$choices = @("Batman", "Superman", "Flash")

    foreach ($item in $choices) {
        $obj_search_box.Items.Add($item)
    }

    #This creates a output box
    $obj_output_box = New-Object System.Windows.Forms.TextBox 
    $obj_output_box.Location = New-Object System.Drawing.Size(10,60) 
    $obj_output_box.Size = New-Object System.Drawing.Size(580,425)
    $obj_output_box.Multiline = $True
    $obj_output_box.TabIndex = 0 
    $Test_Form.Controls.Add($obj_output_box)
    
    # Search Button
    $Search_Button = New-Object System.Windows.Forms.Button
    $Search_Button.Location = New-Object System.Drawing.Point(175,29)
    $Search_Button.Size = New-Object System.Drawing.Size(98,23)
    $Search_Button.BackColor = "LightGray"
    $Search_Button.Text = "Search"
    $Search_Button.Add_Click({ wiki_search })
    $Test_Form.Controls.Add($Search_Button)

    # Render Form
    $Test_Form.Add_Shown({$Test_Form.Activate()})
    $Test_Form.ShowDialog() | Out-Null
    $Test_Form.Dispose() | Out-Null


}
test_app