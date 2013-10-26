// Global variables
var xmlHttpTimer;

function initFlyout() {
    // Set XML status provider URL
    var url = System.Gadget.Settings.read("xmlProviderUrl") + "?node=host&node=service&elem=current_state&elem=plugin_output";
    var xmlProviderUser = System.Gadget.Settings.read("xmlProviderUser");
    var xmlProviderPass = System.Gadget.Settings.read("xmlProviderPass");

    // Get source XML
    var xmlHttpObj = new XMLHttpRequest();
    xmlHttpTimer = setTimeout(function() {
        xmlHttpObj.abort();
        flyoutOutput.innerHTML = "XML Status Request timed out! Please check XML Provider URL setting.";
    }, 90000);
    xmlHttpObj.onreadystatechange = function() { updateFlyout(xmlHttpObj) };
    xmlHttpObj.open('GET',url,true,xmlProviderUser,xmlProviderPass);
    xmlHttpObj.send(null);
}

function updateFlyout(xmlHttpObj) {
    if (xmlHttpObj.readyState == 4) {
        // Response complete, clear timeout timer
        clearTimeout(xmlHttpTimer);
        
        // Check that we got HTTP 200/OK
        if (xmlHttpObj.status != 200) {
            flyoutOutput.innerHTML = "Unable to retrieve Nagios status XML! Server response was: " + xmlHttpObj.status + " " + xmlHttpObj.statusText;
            end;
        }
        
        // Initialize DOM document object for status XML
        var xmlStatus = new ActiveXObject("Msxml2.DOMDocument.3.0");
        xmlStatus.async=false;
        xmlStatus.load(xmlHttpObj.responseXML);
        
        // Open XSLT template
        var flyoutXSLT = new ActiveXObject("Msxml2.DOMDocument.3.0");
        flyoutXSLT.async=false;
        flyoutXSLT.load("NagstatusFlyout.xsl");
        
        if (xmlStatus.parseError.errorCode != 0) {
            flyoutOutput.innerHTML = "Error parsing XML status file!";
        } else if (flyoutXSLT.parseError.errorCode != 0) {
            flyoutOutput.innerHTML = "Error parsing XSL template!";
        } else {
            // Transform status XML into HTML using flyoutXSLT
            flyoutOutput.innerHTML = xmlStatus.transformNode(flyoutXSLT);
        }
    }
}

function openNagiosExtinfo(host, service) {
    if (service == '') {
        var url = System.Gadget.Settings.read("nagiosExtinfoUrl")
        + '?type=1&host=' + escape(host);
    } else {
        var url = System.Gadget.Settings.read("nagiosExtinfoUrl")
        + '?type=2&host=' + escape(host)
        + '&service=' + escape(service);
    }
    navigate(url);
    return false;
}

function openNagiosUrl() {
    if (System.Gadget.Settings.read("nagiosUrl") != "") {
        navigate(System.Gadget.Settings.read("nagiosUrl"));
    }
    return false;
}
