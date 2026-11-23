param([int]$Port = 8085)
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$Port/")
$listener.Start()
Write-Host "Server listening on http://localhost:$Port/"

$filePath = "C:\Users\bogda\.gemini\antigravity\scratch\bank-sknerus-mobile\index.html"

while ($listener.IsListening) {
    try {
        $context = $listener.GetContext()
        $response = $context.Response
        if ([System.IO.File]::Exists($filePath)) {
            $bytes = [System.IO.File]::ReadAllBytes($filePath)
            $response.ContentType = "text/html; charset=utf-8"
            $response.ContentLength64 = $bytes.Length
            $response.OutputStream.Write($bytes, 0, $bytes.Length)
        } else {
            $response.StatusCode = 404
        }
        $response.OutputStream.Close()
    } catch {
        break
    }
}
$listener.Stop()
