# Sample Web App

http://bixi.herokuapp.com/map.html (Montreal)

# API Usage

http://bixi.herokuapp.com/montreal

http://bixi.herokuapp.com/ottawa

http://bixi.herokuapp.com/toronto

# Warning

Bixi does not provide an official API for querying station data. This application
relies on parsing javascript from `https://montreal.bixi.com/maps/statajax`,
which may change without notice.

# Caching

Data for each city is cached in memory for 5 minutes to avoid overwhelming the Bixi servers and getting banned.