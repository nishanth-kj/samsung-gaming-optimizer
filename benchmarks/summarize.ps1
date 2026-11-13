param([Parameter(Mandatory=$true)][string]$Dir)
# Summarizes a benchmark folder: Free Fire MAX frame stats, temps, RAM, ping.
$ErrorActionPreference = 'Continue'
$out = @()
$ts = Join-Path $Dir 'timestats-raw.txt'
if (Test-Path $ts) {
  $lines = Get-Content $ts
  $best = $null; $cur = $null
  foreach ($l in $lines) {
    if ($l -match '^layerName = (.*)') { $cur = @{ name = $Matches[1]; frames = 0; fps = 0; hist = $null } ; if ($Matches[1] -match 'freefire') { $cur.ff = $true } }
    elseif ($cur -and $cur.ff) {
      if ($l -match '^totalFrames = (\d+)') { $cur.frames = [int]$Matches[1] }
      elseif ($l -match '^averageFPS = ([\d.]+)') { $cur.fps = [double]$Matches[1] }
      elseif ($l -match '^0ms=' -and -not $cur.hist) { $cur.hist = $l; if (-not $best -or $cur.frames -gt $best.frames) { $best = $cur } }
    }
  }
  if ($best) {
    $bins = @{}; foreach ($kv in $best.hist -split ' ') { if ($kv -match '^(\d+)ms=(\d+)$') { $bins[[int]$Matches[1]] = [int]$Matches[2] } }
    $total = ($bins.Values | Measure-Object -Sum).Sum
    $slow = ($bins.GetEnumerator() | Where-Object { $_.Key -ge 33 } | Measure-Object -Property Value -Sum).Sum
    $big  = ($bins.GetEnumerator() | Where-Object { $_.Key -ge 50 } | Measure-Object -Property Value -Sum).Sum
    $top = $bins.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 3 | ForEach-Object { "$($_.Key)ms x$($_.Value)" }
    $out += "Free Fire MAX frames : $($best.frames)  avg FPS: $([math]::Round($best.fps,1))"
    $out += "Most common frame gaps: $($top -join ', ')   (even pacing = one dominant value)"
    $out += "Stutters >=33ms      : $slow  ($([math]::Round(100*$slow/[math]::Max($total,1),2))%)   big stutters >=50ms: $big"
  } else { $out += "No Free Fire frames recorded (was the game open during the test?)" }
}
foreach ($f in 'after-game-thermal.txt','idle-thermal.txt','thermal.txt') {
  $p = Join-Path $Dir $f
  if (Test-Path $p) {
    $t = Get-Content $p
    $st = ($t | Select-String 'Thermal Status: (\d)' | Select-Object -First 1).Matches.Groups[1].Value
    $vals = foreach ($n in 'AP','SKIN','BAT') { $m = $t | Select-String "mValue=([\d.]+), mType=\d+, mName=$n," | Select-Object -First 1; if ($m) { "$n=$($m.Matches.Groups[1].Value)C" } }
    $out += "$($f.PadRight(22)): status $st  $($vals -join ' ')"
  }
}
$mi = Join-Path $Dir 'idle-meminfo.txt'
if (Test-Path $mi) { $out += ((Get-Content $mi | Select-String 'Free RAM:') -replace '\s+',' ').Trim() }
foreach ($f in 'ping-google.txt','ping-cloudflare.txt') {
  $p = Join-Path $Dir $f
  if (Test-Path $p) { $c = Get-Content $p; $out += "$f : " + (($c | Select-String 'packet loss') -replace '.*received, ','') + ' | ' + (($c | Select-String 'rtt') -replace '.*= ','min/avg/max/jitter = ') }
}
$out | Tee-Object -FilePath (Join-Path $Dir 'summary.txt')
