<?php

// Runs one test file in a child process and stores its Xdebug coverage data.
function runTestFile($testFile, $coverageFile)
{
    $command = escapeshellarg(PHP_BINARY)
        . ' -d xdebug.mode=coverage '
        . escapeshellarg(__FILE__)
        . ' --run-test '
        . escapeshellarg($testFile)
        . ' '
        . escapeshellarg($coverageFile)
        . ' 2>&1';

    $output = array();
    $exitCode = 0;
    exec($command, $output, $exitCode);
    echo implode(PHP_EOL, $output), PHP_EOL;

    if ($exitCode !== 0 || stripos(implode(PHP_EOL, $output), 'assert failed') !== false) {
        throw new RuntimeException("Test failed: {$testFile}");
    }
}

// Merges Xdebug line data and prints per-file and total coverage.
function reportCoverage($coverageFiles, $sourceRoot)
{
    $merged = array();
    foreach ($coverageFiles as $coverageFile) {
        $coverage = json_decode(file_get_contents($coverageFile), true);
        if (!is_array($coverage)) {
            throw new RuntimeException("Invalid coverage data: {$coverageFile}");
        }

        foreach ($coverage as $sourceFile => $lines) {
            $realSourceFile = realpath($sourceFile);
            if ($realSourceFile === false || strpos($realSourceFile, $sourceRoot) !== 0) {
                continue;
            }

            foreach ($lines as $line => $status) {
                if (!isset($merged[$realSourceFile][$line]) || $status > $merged[$realSourceFile][$line]) {
                    $merged[$realSourceFile][$line] = $status;
                }
            }
        }
    }

    ksort($merged);
    $totalLines = 0;
    $coveredLines = 0;
    foreach ($merged as $sourceFile => $lines) {
        $fileLines = count($lines);
        $fileCoveredLines = count(array_filter($lines, function ($status) {
            return $status > 0;
        }));
        $percentage = $fileLines === 0 ? 0 : $fileCoveredLines * 100 / $fileLines;

        printf("%-36s %6.2f%% (%d/%d)%s", basename($sourceFile), $percentage, $fileCoveredLines, $fileLines, PHP_EOL);
        $totalLines += $fileLines;
        $coveredLines += $fileCoveredLines;
    }

    if ($totalLines === 0) {
        throw new RuntimeException('No PHP source coverage was collected');
    }

    printf("PHP total line coverage: %.2f%% (%d/%d)%s", $coveredLines * 100 / $totalLines, $coveredLines, $totalLines, PHP_EOL);
}

if (isset($argv[1]) && $argv[1] === '--run-test') {
    xdebug_start_code_coverage(XDEBUG_CC_UNUSED | XDEBUG_CC_DEAD_CODE);
    chdir(__DIR__);
    require $argv[2];
    file_put_contents($argv[3], json_encode(xdebug_get_code_coverage()));
    exit(0);
}

if (!extension_loaded('xdebug')) {
    throw new RuntimeException('Xdebug is required for PHP coverage');
}

$coverageDirectory = sys_get_temp_dir() . '/agora-php-coverage-' . getmypid();
if (!mkdir($coverageDirectory, 0777, true) && !is_dir($coverageDirectory)) {
    throw new RuntimeException("Cannot create coverage directory: {$coverageDirectory}");
}

$coverageFiles = array();
foreach (glob(__DIR__ . '/*Test.php') as $index => $testFile) {
    $coverageFile = $coverageDirectory . '/' . $index . '.json';
    runTestFile($testFile, $coverageFile);
    $coverageFiles[] = $coverageFile;
}

reportCoverage($coverageFiles, realpath(__DIR__ . '/../src') . DIRECTORY_SEPARATOR);
