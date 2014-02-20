#!/bin/sh -u

alias pandoc='/c/Users/JKK0544/AppData/Local/Pandoc/pandoc.exe'

pandoc -f markdown -t html5 <<-__EOM__
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>HTML5メモ</title>
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="css/bootstrap.min.css">
<!-- Optional theme -->
<link rel="stylesheet" href="css/bootstrap-theme.min.css">
<!-- Latest compiled and minified JavaScript -->
<script src="js/bootstrap.min.js"></script></head>
<body>
# DATAPUMP metadata_only
>	DB-ORACLE-DATAPUMP

## メタ情報のエクスポート

    #!bash
    expdp hr/hr DIRECTORY=dpump_dir1 DUMPFILE=hr_comp.dmp COMPRESSION=METADATA_ONLY



###Writting code ###

    #!javascript
    function hi(){
        alert('hi!');
    }


</body>
</html>
__EOM__

