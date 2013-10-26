// Set Settings UI
System.Gadget.settingsUI = "NagstatusSettings.html";

// Set Flyout file
System.Gadget.Flyout.file = "NagstatusFlyout.html";

// Set Settings commit delegate
System.Gadget.onSettingsClosed = closedSettings;

// Global variables
var xmlProviderUrl = "";
var xmlProviderUser = "";
var xmlProviderPass = "";
var windowTitle = "";
var refreshInterval;
var xmlStatus;
var xmlHttpTimeout;
var xmlHttpObj;
var lastStateChange = 0;

function updateStats() {

    if (xmlProviderUrl == "") {
        output.innerHTML = "XML Provider URL is unset, please enter a valid URL in settings.";
        end;
    }
    
    // Set request URL
    if (System.Gadget.Settings.read("xmlProviderType") == 'file') {
        var url = xmlProviderUrl + "?" + Math.random();
    } else {
        var url = xmlProviderUrl + "?node=host&node=service&elem=current_state&elem=plugin_output&elem=problem_has_been_acknowledged&elem=last_state_change&node=program&elem=program_start&elem=last_command_check&elem=scheduled_downtime_depth";
    }
    
    // Get source XML (in case previous request has finished)
    xmlHttpObj = new XMLHttpRequest();
    xmlHttpTimer = setTimeout(function() {
        xmlHttpObj.abort();
        output.innerHTML = "XML Status Request timed out! Please check XML Provider URL setting.";
    }, 90000);
    xmlHttpObj.onreadystatechange = function() {
        updateGadget();
        updateFlyout();
    }
    xmlHttpObj.open('GET',url,true,xmlProviderUser,xmlProviderPass);
    xmlHttpObj.send(null);
}

function updateGadget() {
    
    if (xmlHttpObj.readyState == 4) {
        // HTTP request is complete, clear timeout counter
        clearTimeout(xmlHttpTimer);
        
        // Check status
        if (xmlHttpObj.status != 200) {
            output.innerHTML = "Unable to retrieve Nagios status XML! Server response was: " + xmlHttpObj.status + " " + xmlHttpObj.statusText;
            end;
        }
        
        // Initialize DOM document object for status XML
        var xmlStatus = new ActiveXObject("Msxml2.DOMDocument.3.0");
        xmlStatus.async=false;
        xmlStatus.load(xmlHttpObj.responseXML);
        
        // Initialize DOM document object for XML stylesheet
        var xsltXml= new ActiveXObject("Msxml2.DOMDocument.3.0");
        xsltXml.async = false;
        xsltXml.load("Nagstatus.xsl");
        
        // Check if the XML's are parseable 
        if ((xmlStatus.parseError.errorCode == 0) && (xsltXml.parseError.errorCode == 0)) {
            // Transform status XML into output HTML using xslt transformation
            output.innerHTML = xmlStatus.transformNode(xsltXml);
            windowtitlearea.innerHTML = System.Gadget.Settings.read("windowTitle");
            // See if we have a statechange since lastStateChange
            if ((lastStateChange != 0) && (xmlStatus.selectSingleNode('/nagstatus/program/last_state_change').text > lastStateChange)) {
                // Play alert sound & display visual effect
                alertFX();
            }
            lastStateChange = xmlStatus.selectSingleNode('/nagstatus/program/last_state_change').text;
        } else {
            // XML's were not parseable
            output.innerHTML = "Error parsing status XML!";
        }
    }
}

function updateFlyout() {
    if (System.Gadget.Flyout.show) {
        // Get pointer to flyout DOM object
        var flyoutDoc = System.Gadget.Flyout.document;

        // Initialize DOM document object for status XML
        var xmlStatus = new ActiveXObject("Msxml2.DOMDocument.3.0");
        xmlStatus.async=false;
        xmlStatus.load(xmlHttpObj.responseXML);

        // Initialize DOM object for flyout XSLT template
        var flyoutXSLT = new ActiveXObject("Msxml2.DOMDocument.3.0");
        flyoutXSLT.async=false;
        flyoutXSLT.load("NagstatusFlyout.xsl");
        
        if (xmlStatus.parseError.errorCode != 0) {
            flyoutDoc.getElementById("flyoutOutput").innerHTML = "Error parsing XML status file!";
        } else if (flyoutXSLT.parseError.errorCode != 0) {
            flyoutDoc.getElementById("flyoutOutput").innerHTML = "Error parsing XSL template!";
        } else {
            // Transform status XML into HTML using flyoutXSLT
            var outputXML = xmlStatus.transformNode(flyoutXSLT);
            flyoutDoc.getElementById("flyoutOutput").innerHTML = outputXML;
        }
    }
}

function init() {
    // Load settings
    windowTitle = System.Gadget.Settings.read("windowTitle");
    xmlProviderUrl = System.Gadget.Settings.read("xmlProviderUrl");
    xmlProviderUser = System.Gadget.Settings.read("xmlProviderUser");
    xmlProviderPass = System.Gadget.Settings.read("xmlProviderPass");
    
    // Set autorefresh
    if (!(System.Gadget.Settings.read("refreshTimeoutSec") > 0)) {
        System.Gadget.Settings.write("refreshTimeoutSec", 60);
    }
    refreshInterval = window.setInterval("updateStats()", System.Gadget.Settings.read("refreshTimeoutSec") * 1000);
    
    // Load stats & update display
    updateStats();
}

function closedSettings() {
    // Settings have been closed
    // Clear refreshInterval in case it has been changed
    window.clearInterval(refreshInterval);
 
    // Refresh gadget with new settings
    init();
}

function gadgetClicked() {
    if (System.Gadget.Flyout.show == true) {
        System.Gadget.Flyout.show = false;
    } else {
        System.Gadget.Flyout.show = true;
        System.Gadget.Flyout.onShow = function() { updateFlyout(); }
    }
}

function alertFX() {
    if (System.Gadget.Settings.read("alertSound") != "") {
        System.Sound.playSound(System.Gadget.Settings.read("alertSound"));
    }
    for (var j = 0; j<=5; j++) {
        for (var i = 0; i<=100; i++) {
            var opaqueness = 100-i;
            var strCall = "setGlow(" + opaqueness + ")";
            setTimeout(strCall,(j*1000)+(i*10));
        }
    }    
}

function setGlow(opaqueness) {
    var oBackground = document.getElementById("imgBackground");
    oBackground.addGlow("red",100,opaqueness);
}
