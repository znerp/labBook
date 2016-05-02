
var make_lndcsp_links = function() {
      
      $(".lndscp-timeline").each(function(){
        
        $(this).css("width","1400px");
        var span_start = "<span class='lndscp_span'>";
        var img_link   = $(this)[0].outerHTML;
        var sample_links = "";
        var img_width = $(this).width();
        
        var sub_num = $(this).attr("name");
        var id_days = $(this).attr("id");
        id_days = id_days.split(" ");
        jQuery.each(id_days, function(i,id_day){
          id_day  = id_day.split(":");
          num_days  = Number(id_day[1]);
          sample_id = id_day[0];
          sample_id = sub_num + "_" + sample_id;
          var left_indent = ((num_days+100)/4968)*img_width;
          left_indent = Math.round(left_indent);
          sample_link = '<a href="lndscps/nic_'+sample_id+'_lndscp-3D.html"><div class="lndscp_link" style="left:'+left_indent+'px;"></div></a>';
          sample_links = sample_links + sample_link;
          //alert(num_days);
        })
        
        // Now output sub_id
        var sub_id_div = '<div class="sub_id">'+sub_num+'</div>';
        
        var span_end = "</span>";
        var new_html = span_start + img_link + sub_id_div + sample_links + span_end;
        
        $(this).replaceWith(new_html);
      });
      
    }
    
    $(document).ready(make_lndcsp_links);

