function ready_foot(id){
	var xml_bm = 'xml/foot.xml';
	var cont = $("#"+id);
	XMLLoad.loadTxt(xml_bm,function(txt){
		cont.append(txt);
	});
}

