function Show-RandomKanyeQuote {
    param (
        [string]$apiUrl = "https://api.kanye.rest/",
        [string]$memeImageUrl = "https://i.imgflip.com/faf6c.jpg"
    )

    <#
    .SYNOPSIS
        This function creates a Windows Form application (GUI) that displays a random Kanye West quote on a meme image background.
        
    .DESCRIPTION
        This function uses Windows Forms and Drawing libraries to create a GUI application that fetches random Kanye West quotes 
        from an API (https://api.kanye.rest/) and displays them on a meme image background. The quote is displayed in a label
        with a semi-transparent background, white text, and a neon yellow border. The label's text is updated with a new quote
        when clicked.

    .EXAMPLE
        To run the function, simply call it in PowerShell:
        ```powershell
        Show-RandomKanyeQuote
        ```

    .NOTES
        Author: Richard Hollon
        Date: 01/06/2025
        Version: 1.0

    .COMPONENT
        This function requires the System.Windows.Forms and System.Drawing assemblies.
    #>

    # Add the necessary .NET assembly references for Windows Forms and Drawing.
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    # Download the meme image from the URL
    $webClient = New-Object System.Net.WebClient
    $memeImageStream = $webClient.OpenRead($memeImageUrl)
    $memeImage = [System.Drawing.Image]::FromStream($memeImageStream)

    # Create the form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Random Kanye West Quote"
    $form.Size = New-Object System.Drawing.Size(800, 600)
    $form.StartPosition = "CenterScreen"
    $form.AutoScaleMode = "Font"
    $form.MaximizeBox = $false
    $form.BackgroundImage = $memeImage
    $form.BackgroundImageLayout = [System.Windows.Forms.ImageLayout]::Stretch

    # Create a label to display the quote
    $quoteLabel = New-Object System.Windows.Forms.Label
    $quoteLabel.Font = New-Object System.Drawing.Font("Tahoma", 18, [System.Drawing.FontStyle]::Bold)
    $quoteLabel.ForeColor = [System.Drawing.Color]::White
    $quoteLabel.BackColor = [System.Drawing.Color]::FromArgb(100, [System.Drawing.Color]::White)
    $quoteLabel.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
    $quoteLabel.Padding = New-Object System.Windows.Forms.Padding(10)
    $quoteLabel.AutoSize = $true
    $quoteLabel.MaximumSize = New-Object System.Drawing.Size(($form.ClientSize.Width - 40), 0) # Margin of 20 on each side

    # Function to fetch a random quote from the API and update the label text
    function Update-Quote {
        $response = Invoke-RestMethod -Uri $apiUrl
        $quoteLabel.Text = $response.quote
        Position-Label
    }

    # Position the label at the top center of the form
    function Position-Label {
        $quoteLabel.Location = New-Object System.Drawing.Point(
            [math]::Max(0, ($form.ClientSize.Width - $quoteLabel.PreferredWidth) / 2),
            85 # Adjust the value 20 for margin from the top
        )
    }

    # Fetch the initial quote
    Update-Quote

    $form.Add_Shown({
        Position-Label
    })

    $form.Add_SizeChanged({
        $quoteLabel.MaximumSize = New-Object System.Drawing.Size(($form.ClientSize.Width - 40), 0) # Margin of 20 on each side
        Position-Label
    })

    # Add the label to the form
    $form.Controls.Add($quoteLabel)

    # Set the border color to neon yellow (tennis ball color)
    $quoteLabel.Add_Paint({
        $graphics = $_.Graphics
        $rect = $quoteLabel.ClientRectangle
        $pen = New-Object System.Drawing.Pen([System.Drawing.Color]::YellowGreen, 4)
        $graphics.DrawRectangle($pen, 0, 0, $rect.Width - 1, $rect.Height - 1)
    })

    # Add the Click event handler to the quoteLabel
    $quoteLabel.Add_Click({
        Update-Quote
    })

    # Show the form
    $form.ShowDialog()
}

# call the function
Show-RandomKanyeQuote