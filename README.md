# ownCloud-Pack
Place this two file in anywhere you want to pack owncloud.

    pack.sh
    moe.ini

# .ini File
One ini file for one customer. You can create another ini file based on **moe.ini** file. 

# pack.sh File
This **pack.sh** file will update your owncloud app to the latest according to **moe.ini** file.

#  Executing script
Sample:

    ./pack.sh --config moe.ini -v
