$(document).ready(function () {
    //var user holds a key->item of checkboxes from Front.html and booleancheck corresponding to key[0->4]
    //function check_boxes called every click to check true/false for checkboxes
    var user = {
        pdfcheck: document.getElementById("pdf"), //user.booleancheck[0]
        list_all: document.getElementById("all_class"), //user.booleancheck[1]
        division: document.getElementById("divs"), //user.booleancheck[2]
        quali: document.getElementById("quali"), //user.booleancheck[3]
        req: document.getElementById("req"), //user.booleancheck[4]
        booleancheck: [false, false, 'low', false, false],
    }

    $('#CS').click(function (e) {
        e.preventDefault();
        check_boxes(user, user.booleancheck);
        if (user.booleancheck[0] == true) {
            ajax_pdf("CS");
        } else {
            ajax_request("CS", user.booleancheck);
        }
    });
    $('#EE').click(function (e) {
        e.preventDefault();
        check_boxes(user, user.booleancheck);
        if (user.booleancheck[0] == true) {
            ajax_pdf("EE");
        } else {
            ajax_request("EE", user.booleancheck);
        }
    });
    $('#CE').click(function (e) {
        e.preventDefault();
        check_boxes(user, user.booleancheck);
        if (user.booleancheck[0] == true) {
            ajax_pdf("CE");
        } else {
            ajax_request("CE", user.booleancheck);
        }
    });
    //check_boxes(user,booleancheck), changes booleancheck to corresponding user data
    //format to call check_boxes --> check_boxes(user, user.booleancheck)
    function check_boxes(user, booleancheck) {
        if (user.pdfcheck.checked == true) {
            user.booleancheck[0] = true;
        }
        else {
            user.booleancheck[0] = false;
        }
        if (user.list_all.checked == true) {
            user.booleancheck[1] = true;
        }
        else {
            user.booleancheck[1] = false;
        }
        if (user.division.checked == true) {
            user.booleancheck[2] = 'high';
        }
        else {
            user.booleancheck[2] = 'low';
        }
        if (user.quali.checked == true) {
            user.booleancheck[3] = true;
        }
        else {
            user.booleancheck[3] = false;
        }
        if (user.req.checked == true) {
            user.booleancheck[4] = true;
        } else {
            user.booleancheck[4] = false;
        }
    }
    //ajax_pdf(Major), http GET request for pdf of "Major"
    //format to call ajax_pdf --> ajax_pdf("MAJOR") where MAJOR == CS/CE/EE
    function ajax_pdf(Major) {
        $.ajax({
            type: "GET", //change to POST if GET doesn't work
            url: "http://localhost:5001/request", //url of html,
            //change it to 'JSONLOCATION if it doesnt work'
            headers: {
                "Chart": true,
                "Major": Major,
            },
            success: function (data) {
                window.location = data;
                //window.location = 'https://undergrad.soe.ucsc.edu/sites/default/files/file-content-type/2021-10/CMPE_21-22.pdf';       

            },
            error: function (result) {
                alert('error');
            }
        });
    }
    //ajax_request(Major, booleancheck), http GET request for lists of classes with flags
    //format to call ajax_request --> ajax_request("MAJOR", user.booleancheck) where MAJOR == CS/CE/EE
    //booleancheck == user.booleancheck (var user struct at the top for details)
    function ajax_request(Major, booleancheck) {
        $.ajax({
            type: "GET", //change to POST if GET doesn't work
            url: "http://localhost:5001/request", //url of html,
            //change it to 'JSONLOCATION if it doesnt work'
            headers: {
                "Major": Major,
                "List_all": booleancheck[1],
                "Division": booleancheck[2],
                "Quali": booleancheck[3],
                "Req": booleancheck[4]

            },
            success: function (data) {
                //alert(data);
                var cname;
                var result = document.getElementById("result");
                var obj = JSON.parse(data);
                var classes = obj.Class;
                var thead = '<div><table border="1">\n';
                var tbody = '<tr><th>';
                tbody += Major;
                if (user.list_all.checked == true) {
                    tbody += " Classes"
                }
                else if (user.division.checked == true) {
                    tbody += " Upperdivision Classes";
                }
                else {
                    tbody += " Lowerdivision Classes";
                }
                tbody += '</th>';
                tbody += '<th>';
                tbody += "GE requirements fulfilled";
                tbody += '</th>';
                tbody += '</tr>\n';
                for (value in classes) {
                    //value in obj.Class
                    cname = JSON.stringify(obj.Class[value], value).replace(/['"]+/g, '')
                    tbody += '<tr>';

                    //Create table cell for class and title
                    tbody += '<td class = "cname">';
                    tbody += cname + ": " + JSON.stringify(obj.Title[cname]).replace(/['"]+/g, '');

                    //Creating popup with description and prerequisite
                    tbody += '<span class = "desc">';
                    tbody += "Description: " + JSON.stringify(obj.Desc[cname]).replace(/['"]+/g, '') + "\n";
                    tbody += "Prerequisites: " + JSON.stringify(obj.Preq[cname]).replace(/['"]+/g, '') + "\n";
                    tbody += '</span>';
                    tbody += '</td>';

                    //Create cell for GE
                    tbody += '<td>';
                    tbody += JSON.stringify(obj.GE[cname]).replace(/['"]+/g, '');
                    tbody += '</td>';
                    tbody += '</tr>\n';
                }
                var tfoot = '</table></div>';
                result.innerHTML = thead + tbody + tfoot;


            },
            error: function (result) {
                alert('error');
            }
        });

    }

});


