<?php

include_once ('index.html');

// Connects to the XE service (i.e. database) on the "localhost" machine
$conn = oci_connect('system', 'kubabaza', 'localhost/xe');
if (!$conn) {
    $e = oci_error();
    trigger_error(htmlentities($e['message'], ENT_QUOTES), E_USER_ERROR);
}

$stid = oci_parse($conn, 'SELECT * FROM WINDOW_1');
oci_execute($stid);

echo "<h3 align='center'> Ilość zarobionych pieniędzy na różnych atrakcjach oraz ich suma ogólna </h3>";

echo "<table border='1'; align='center'>\n";
echo "<td>Data</td>";
echo "<td>Atrakcja</td>";
echo "<td>Zarobki</td>";
echo "<td>Suma zarobkow</td>";
while ($row = oci_fetch_array($stid, OCI_ASSOC+OCI_RETURN_NULLS)) {
    echo "<tr>\n";
    foreach ($row as $item) {
        echo "    <td>" . ($item !== null ? htmlentities($item, ENT_QUOTES) : "&nbsp;") . "</td>\n";
    }
    echo "</tr>\n";
}
echo "</table>\n";

?>