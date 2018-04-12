window.showSpoiler = function (obj)
{
    var inner = obj.parentNode.getElementsByTagName("div")[0];       
    if (inner.style.display == "none")
    {     
        obj.style.display = "none";   
        inner.style.display = "";
    }
    else
        inner.style.display = "none";
    }
}