<?php

include_once ('index.html');

// Connects to the XE service (i.e. database) on the "localhost" machine
$conn = oci_connect('system', 'kubabaza', 'localhost/xe');
if (!$conn) {
    $e = oci_error();
    trigger_error(htmlentities($e['message'], ENT_QUOTES), E_USER_ERROR);
}
$stid = oci_parse($conn, 'SELECT * FROM GROUPING_1');
oci_execute($stid);

echo "<h3 align='center'>Ilość tranzakcji w róznych miastach na atrakcjach uwględniajc czy placono karta czy gotowka </h3>";

echo "<table border='1'; align='center'>\n";
echo "<td>Miasto</td>";
echo "<td>Atrakcja</td>";
echo "<td>Rodzaj platnosc</td>";
echo "<td>Ilosc platnosci</td>";
while ($row = oci_fetch_array($stid, OCI_ASSOC+OCI_RETURN_NULLS)) {
    echo "<tr>\n";
    foreach ($row as $item) {
        echo "    <td>" . ($item !== null ? htmlentities($item, ENT_QUOTES) : "&nbsp;") . "</td>\n";
    }
    echo "</tr>\n";
}
echo "</table>\n";

?>