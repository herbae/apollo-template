group webform;

form_twocolumns() ::= "false"


form(formuri,enctype,errormessage,mandatorymessage,formconfig,fields,submitbutton,resetbutton,hiddenfields,prevbutton,subfieldjs) ::= <<
$! ###### Main input form ###### !$
$if(formconfig.formText)$$formconfig.formText$$endif$

<form name="emailform$formconfig.configId$" id="emailform$formconfig.configId$" action="$formuri$"
	method="post" class="sky-form"$enctype$>

$! --- show validation errors -- !$
$if(errormessage)$
	<header>
		$errormessage$
	</header>
$endif$	

<div style="display: none;"><input type="hidden" name="formaction$formconfig.configId$" id="formaction$formconfig.configId$" value="submit" /></div>
<fieldset>
	$fields$
</fieldset>

$if(formconfig.formMiddleText)$
  $! --- show form middle text --- !$
  <fieldset> 
  	$formconfig.formMiddleText$
  </fieldset>
$endif$

<footer>
$! --- show mandatory note --- !$
$if(mandatorymessage)$
	<section><div class="note">$mandatorymessage$</div></section>
$endif$

$! --- show submit, reset and previous button --- !$
$if(submitbutton)$

		$hiddenfields$
		$if(prevbutton)$
			<input type="submit" value="$prevbutton$" name="back" class="formbutton btn btn-grey prevbutton" />
		$endif$
		<input type="submit" value="$submitbutton$" class="formbutton btn btn-default submitbutton" />  
		$if(resetbutton)$
			&nbsp;<input type="reset" value="$resetbutton$" class="formbutton btn btn-grey resetbutton" />
		$endif$

$endif$

</footer>
</form>

$! --- JavaScript for sub fields --- !$
$if(subfieldjs)$
	<script type="text/javascript">$subfieldjs$</script>
$endif$

$if(formconfig.formFooterText)$
  $! --- show form footer text --- !$
  <div class="mt-20">$formconfig.formFooterText$</div>
$endif$

>>


form_js(formconfig,sessionjs,sessionuri,subfieldjs) ::= <<
$! ###### JAVASCRIPT for Main input form ###### !$
$if(sessionjs)$
<script type="text/javascript" src="$sessionjs$"></script>
<script type="text/javascript">
	var formgenRefreshSessionTimeout = $formconfig.refreshSessionInterval$;var formgenKeepSessionURI = "$sessionuri$";
	setTimeout("formgenKeepSession();", $formconfig.refreshSessionInterval$);
</script>
$endif$
<script type="text/javascript" src="$subfieldjs$"></script>
>>


field_captcha(field,formconfig,attributes,errormessage,mandatory,captcha) ::= <<
$! ###### CAPTCHA field ###### !$
$row_start(field=field)$
$label(field=field,formconfig=formconfig,errormessage=errormessage,mandatory=mandatory)$
<label class="input$if(errormessage)$ state-error$endif$">
	$captcha$
	<input type="text" name="$field.name$" value="$field.valueEscaped$" />
</label>
$if(errormessage)$
	<div class="note note-error">$errormessage$</div>
$endif$
$row_end(field=field,formconfig=formconfig)$
>>


field_checkbox(field,formconfig,attributes,errormessage,mandatory) ::= <<
$! ###### Checkbox field ###### !$
$row_start(field=field)$
$label(field=field,formconfig=formconfig,errormessage=errormessage,mandatory=mandatory)$
$if(field.parameters)$$if(field.parameters.toggle)$$else$<div class="inline-group">$endif$$else$<div class="inline-group">$endif$
	$field.items:{
		<label class="$if(field.parameters)$$if(field.parameters.toggle)$toggle$else$checkbox$endif$$else$checkbox$endif$$if(errormessage)$ state-error$endif$">
			<input type="checkbox" name="$field.name$" value="$it.value$" class="check"$if(it.selected)$ checked="checked"$endif$/><i></i>$it.label$
		</label>
	}$
$if(field.parameters)$$if(field.parameters.toggle)$$else$</div>$endif$$else$</div>$endif$
$if(errormessage)$
	<div class="note note-error">$errormessage$</div>
$endif$
$row_end(field=field,formconfig=formconfig)$
>>


field_email(field,formconfig,errormessage,mandatory) ::= <<
$! ###### EMAIL field ###### !$
$field_text(field=field,formconfig=formconfig,errormessage=errormessage,mandatory=mandatory)$
>>


field_empty(field,formconfig,attributes,errormessage,mandatory) ::= <<
$! ###### EMPTY field ###### !$
$row_start(field=field)$
<label class="label">&nbsp;</label>
<label class="input">
	$if(field.valueEscaped)$
		$field.valueEscaped$
	$else$
		&nbsp;
	$endif$
</label>
$if(errormessage)$
	<div class="note note-error">$errormessage$</div>
$endif$
$row_end(field=field,formconfig=formconfig)$
>>


field_file(field,formconfig,attributes,errormessage,mandatory,infomessage) ::= <<
$! ###### FILE UPLOAD field ###### !$
$row_start(field=field)$
$label(field=field,formconfig=formconfig,errormessage=errormessage,mandatory=mandatory)$
<label for="$field.name$" class="input input-file$if(errormessage)$ state-error$endif$$if(infomessage)$ state-info$endif$">
	<div class="button">
		<input type="file" name="$field.name$" id="$field.name$" onchange="document.getElementById('$field.name$-Visible').value = this.value" value="$field.valueEscaped$"/>
		$if(field.parameters)$$if(field.parameters.buttontext)$$field.parameters.buttontext$$else$Browse$endif$$else$Browse$endif$
	</div>
	<input type="text" id="$field.name$-Visible" readonly=""$if(field.parameters)$$if(field.parameters.placeholder)$ placeholder="$field.parameters.placeholder$"$endif$$endif$>
</label>
$if(errormessage)$
	<div class="note note-error">$errormessage$</div>
$endif$
$if(infomessage)$
	<div class="note note-info">$infomessage$</div>
$endif$
$row_end(field=field,formconfig=formconfig)$
>>


field_hidden(field,formconfig,attributes,errormessage,mandatory) ::= <<
$! ###### HIDDEN field ###### !$
<div style="display: none;"><input type="hidden" name="$field.name$" value="$field.valueEscaped$"/></div>
$subtext(field=field,formconfig=formconfig)$
>>


field_paging(field,formconfig,attributes,errormessage,mandatory,hiddenfields,prevbutton,nextbutton,page) ::= <<
$! ###### PAGING field ###### !$
$row_start(field=field)$
<div class="webform_label">&nbsp;</div>
<div class="webform_field">
	$hiddenfields$
	$if(prevbutton)$
	<input type="submit" value="$prevbutton$" name="back$formconfig.configId$" class="formbutton btn prevbutton" />&nbsp;
	$endif$
	<input type="submit" value="$nextbutton$" class="formbutton btn nextbutton" />
	<input type="hidden" name="page$formconfig.configId$" value="$page$" />
</div>
$row_end(field=field,formconfig=formconfig)$
>>


field_password(field,formconfig,attributes,errormessage,mandatory) ::= <<
$! ###### PASSWORD field ###### !$
$row_start(field=field)$
$label(field=field,formconfig=formconfig,errormessage=errormessage,mandatory=mandatory)$
<label class="input$if(errormessage)$ state-error$endif$">
	$if(field.parameters)$
		$if(field.parameters.icon)$
			<i class="icon-$if(field.parameters.position)$$field.parameters.position$$else$prepend$endif$ fa fa-$field.parameters.icon$"></i>
		$endif$
	$endif$
	<input type="password" name="$field.name$" value="$field.valueEscaped$"$if(field.parameters)$$if(field.parameters.placeholder)$ placeholder="$field.parameters.placeholder$"$endif$$endif$/>
</label>
$if(errormessage)$
	<div class="note note-error">$errormessage$</div>
$endif$
$row_end(field=field,formconfig=formconfig)$
>>


field_privacy(field,formconfig,attributes,errormessage,mandatory,label,link,linktext) ::= <<
$! ###### PRIVACY field ###### !$
$row_start(field=field)$
$label(field=field,formconfig=formconfig,errormessage=errormessage,mandatory=mandatory)$
<div class="inline-group">
	$field.items:{
		<label class="checkbox$if(errormessage)$ state-error$endif$">
			<input type="checkbox" name="$field.name$" value="$it.value$" class="check"$if(it.selected)$ checked="checked"$endif$/><i></i><a href="$link$" rel="_blank">$linktext$</a>
		</label>
	}$
</div>
$if(errormessage)$
	<div class="note note-error">$errormessage$</div>
$endif$
$row_end(field=field,formconfig=formconfig)$
>>


field_radio(field,formconfig,attributes,errormessage,mandatory) ::= <<
$! ###### RADIO BUTTONS field ###### !$
$row_start(field=field)$
$label(field=field,formconfig=formconfig,errormessage=errormessage,mandatory=mandatory)$
$field.items:{
	<label class="$if(field.parameters)$$if(field.parameters.toggle)$toggle$else$radio$endif$$else$radio$endif$$if(errormessage)$ state-error$endif$">
	<input type="radio" name="$field.name$" value="$it.value$" class="radio"$if(it.selected)$ checked="checked"$endif$$if(field.hasSubFields)$ onchange="toggleWebformSubFields(this);"$endif$/><i></i>$it.label$
	</label>
}$
$if(errormessage)$
	<div class="note note-error">$errormessage$</div>
$endif$
$row_end(field=field,formconfig=formconfig)$
>>


field_select(field,formconfig,attributes,errormessage,mandatory) ::= <<
$! ###### SELECT field ###### !$
$row_start(field=field)$
$label(field=field,formconfig=formconfig,errormessage=errormessage,mandatory=mandatory)$
<label class="select$if(errormessage)$ state-error$endif$">
	<select name="$field.name$" $if(field.hasSubFields)$ onchange="toggleWebformSubFields(this);"$endif$>
	$field.items:{
		<option value="$it.value$" $if(it.selected)$ selected="selected"$endif$>$it.label$</option>
	}$
	</select>
	<i></i>
</label>
$if(errormessage)$
	<div class="note note-error">$errormessage$</div>
$endif$
$row_end(field=field,formconfig=formconfig)$
>>

field_email_select(field,formconfig,attributes,errormessage,mandatory) ::= <<
$! ###### SELECT field ###### !$
$row_start(field=field)$
$label(field=field,formconfig=formconfig,errormessage=errormessage,mandatory=mandatory)$
<label class="select$if(errormessage)$ state-error$endif$">
	<select name="$field.name$" $if(field.hasSubFields)$ onchange="toggleWebformSubFields(this);"$endif$>
	$field.items:{
		<option value="$it.valueHash$" $if(it.selected)$ selected="selected"$endif$>$it.label$</option>
	}$
	</select>
	<i></i>
</label>
$if(errormessage)$
	<div class="note note-error">$errormessage$</div>
$endif$
$row_end(field=field,formconfig=formconfig)$
>>




field_table(field,formconfig,attributes,errormessage,mandatory,cols,rows,rowswithitems,editable) ::= <<
$! ###### TABLE field ###### !$
$if(!field.showRowStart)$
	</section>
$endif$
<section>
<div class="webform_label_table">
	$field_table_labels(field=field,formconfig=formconfig,errormessage=errormessage,mandatory=mandatory,rows=rows)$
</div>
<div class="webform_field_table">
	$field_table_fields(formconfig=formconfig,cols=cols,rowswithitems=rowswithitems,editable=editable)$
	$if(errormessage)$
	<div class="note note-error">$errormessage$</div>
	$endif$
</div>
</section>
$subtext(field=field,formconfig=formconfig)$
>>


field_table_labels(field,formconfig,errormessage,mandatory,rows) ::= <<
$! ###### Labels for the TABLE field, separate sub template because also used for email generation ###### !$
<table class="table table-bordered table-wf-label"><thead>
	<tr>
		<th>
			$field.label$$mandatory$
		</th>
	</tr>
	$! --- iterate the row names --- !$
	$rows:{
	<tr>
		<th><section>$it$</section></th>
	</tr>
	}$
</thead></table>
>>


field_table_fields(formconfig,cols,rowswithitems,editable) ::= <<
$! ###### Rows for the TABLE field, separate sub template because also used for email generation ###### !$
<table class="table table-bordered table-wf-field"><thead>
	<tr>
	$! --- iterate the column names --- !$
	$cols:{
		<th>$it$</th>
	}$
	</tr>
	</thead>
	<tbody>
	$! --- iterate the rows --- !$
	$rowswithitems:{
	<tr">
		$! --- iterate the items of the row --- !$
		$it:{
		<td>
			$if(editable)$
			<label class="input"><input type="text" name="$it.name$" value="$it.valueEscaped$" class="table"/></label>
			$else$
			<span class="table">$it.valueEscaped$</span>
			$endif$
		</td>
		}$
	</tr>
	}$
</tbody></table>
>>


field_text(field,formconfig,attributes,errormessage,mandatory) ::= <<
$! ###### TEXT field ###### !$
$row_start(field=field)$
$label(field=field,formconfig=formconfig,errormessage=errormessage,mandatory=mandatory)$
<label class="input$if(errormessage)$ state-error$endif$">
	$if(field.parameters)$
		$if(field.parameters.icon)$
			<i class="icon-$if(field.parameters.position)$$field.parameters.position$$else$prepend$endif$ fa fa-$field.parameters.icon$"></i>
		$endif$
	$endif$
	<input type="text" name="$field.name$" value="$field.valueEscaped$"$if(field.parameters)$$if(field.parameters.placeholder)$ placeholder="$field.parameters.placeholder$"$endif$$endif$/>
</label>
$if(errormessage)$
	<div class="note note-error">$errormessage$</div>
$endif$
$row_end(field=field,formconfig=formconfig)$
>>


field_textarea(field,formconfig,attributes,errormessage,mandatory) ::= <<
$! ###### TEXTAREA field ###### !$
$row_start(field=field)$
<label class="label">
	$field.label$$mandatory$
</label>
<label class="textarea$if(errormessage)$ state-error$endif$">
	$if(field.parameters)$
		$if(field.parameters.icon)$
			<i class="icon-$if(field.parameters.position)$$field.parameters.position$$else$prepend$endif$ fa fa-$field.parameters.icon$"></i>
		$endif$
	$endif$
	<textarea cols="5" rows="5" name="$field.name$"$if(field.parameters)$$if(field.parameters.placeholder)$ placeholder="$field.parameters.placeholder$"$endif$$endif$ $attributes$>$field.valueEscaped$</textarea>
</label>
$if(errormessage)$
	<div class="note note-error">$errormessage$</div>
$endif$
$row_end(field=field,formconfig=formconfig)$
>>


label(field,formconfig,errormessage,mandatory) ::= <<
$! ###### Standard LABEL for a field ###### !$
<label class="label">
	$field.label$$mandatory$
</label>
>>


row_start(field) ::= <<
$! ###### Standard start row for a field ###### !$
$if(field.showRowStart)$
	<section>
$endif$
>>


row_end(field,formconfig) ::= <<
$! ###### Standard end row for a field ###### !$
$if(field.showRowEnd)$
	</section>
$endif$
$subtext(field=field,formconfig=formconfig)$
>>


subfieldwrapper(subfields,style,id) ::= <<
$! ###### Sub field wrapper ###### !$
<div class="webform_subfields" id="$id$" style="$style$"><fieldset>
$subfields$
</fieldset></div>
>>


subtext(field,formconfig) ::= <<
$! ###### Intermediate texts for the fields ###### !$
$if(field.hasText)$
	$if(field.showRowStart)$
		<section>
	$endif$
	$if(field.text.columnLeft)$
		<div class="pull-left">
		$field.text.text$
		</div>
	$elseif(field.text.columnRight)$
		<div class="pull-right">
		$field.text.text$
		</div><div class="clearfix"></div>
	$else$
		<div>
		$field.text.text$
		</div>
	$endif$
	$if(field.showRowEnd)$
		</section>
	$endif$
$endif$
>>


checkpage(formuri,formconfig,checktext,captchafield,captchaerror,captchaimagelink,checkfields,hiddenfields,checkbutton,correctbutton) ::= <<
$! ###### CHECK page of the form ###### !$
$checktext$
<table class="table table-bordered table-striped">
$checkfields:{
	<tr>
		<td>$it.label$</td>
		<td>$it.value$</td>
	</tr>
}$
</table>

$if(captchafield)$
	<script type="text/javascript">
		function runConfirmValues() {
			document.getElementById("webformconfirmvalues$formconfig.configId$").elements["$captchafield.name$"].value = "" + document.getElementById("webformcaptcha$formconfig.configId$").elements["$captchafield.name$"].value;
			return true;
		}
	</script>
	<form id="webformcaptcha$formconfig.configId$" action="" method="post" enctype="multipart/form-data" class="sky-form">
	<fieldset>
	$row_start(field=captchafield)$
	<label class="label">
		$captchafield.label$
	</label>
	<div>
		<img src="$captchaimagelink$" class="img-responsive" alt="" />
	</div>
	<label class="input$if(captchaerror)$ state-error$endif$">
		<input type="text" name="$captchafield.name$" value="" />
	</label>
	$if(captchaerror)$
		<div class="note note-error">$captchaerror$</div>
	$endif$
	$row_end(field=captchafield,formconfig=formconfig)$
	</fieldset>
	</form>
$endif$

<div class="sky-form">
	<form id="webformconfirmvalues$formconfig.configId$" method="post" enctype="multipart/form-data" action="$formuri$" onsubmit="return runConfirmValues();">
	<span style="display: none;">
	<input type="hidden" name="formaction$formconfig.configId$" value="confirmed" />
	<input type="hidden" name="captchaphrase$formconfig.configId$" value="" />
	$hiddenfields$
	</span><footer style="border-top: none;">
	<input type="submit" value="$checkbutton$" class="formbutton btn btn-success submitbutton" />
	</form>
	<form id="webformdisplayvalues$formconfig.configId$" method="post" enctype="multipart/form-data" action="$formuri$" class="pull-right">
	<span style="display: none;">
	<input type="hidden" name="formaction$formconfig.configId$" value="correct" />
	$hiddenfields$
	</span>
	<input type="submit" value="$correctbutton$" class="formbutton btn btn-danger correctbutton"/></footer>
	</form>
</div>
>>


confirmationpage(formconfig,confirmtext,confirmfields) ::= <<
$! ###### CONFIRMATION page of the form ###### !$
$confirmtext$
<table class="table table-bordered table-striped">
$confirmfields:{
	<tr>
		<td>$it.label$</td>
		<td>$it.value$</td>
	</tr>
}$
</table>
>>


htmlemail(mailcss,mailtext,errorheadline,errors) ::= <<
$! ###### HTML email for the form ###### !$
<html><head>
<style type="text/css">
$if(mailcss)$
	$mailcss$
$else$
* { font-family: Verdana, Arial, Helvetica, sans-serif;  font-size: 12px; color: #000; }
h1 { font-size: 16px; font-weight: bold; }
p.foot { font-size: 9px; color: #555; }
table.dataform { border-collapse: collapse; border: 1px solid #333; }
table.dataform tr td { border-top: 1px solid #ccc; vertical-align:top; padding: 8px; }
table.dataform tr td.first { border-top: none; }
td.data { font-weight: bold; }
table.table-wf-label { vertical-align: top; }
table.table-wf-label tr th, table.table-wf-label tr td, table.table-wf-field tr th, table.table-wf-field tr td { white-space: nowrap; }
td.table-wf-label { vertical-align: top; }
table.table-wf-field thead, table.table-wf-field tbody, table.table-wf-label thead { margin: 0; padding: 0; }
table.table-wf-label tr th, table.table-wf-field tr td, table.table-wf-field tr th { height: 25px; }
table.table-wf-field tr td { padding-top: 0 !important; padding-bottom: 0 !important; }
table.wtable-wf-label tr th:first-child { vertical-align: middle; }
$endif$
</style>
</head><body>
$mailtext$
$if(errorheadline)$
	<h1>$errorheadline$</h1>
	<p>
	$errors:{
		$it$<br/>
	}$
	</p>
$endif$
</body></html>
>>


htmlemailfields(mailcss,fields) ::= <<
$! ###### FIELDS for the HTML email ###### !$
<table border="0" class="dataform$if(!mailcss)$ fields$endif$">
$first(fields):{
	<tr>
		<td class="first$if(!mailcss)$ fieldlabel$endif$"> $it.label$</td>
		<td class="first$if(mailcss)$ data$else$ fieldvalue$endif$">$it.value$</td>
	</tr>
}$
$rest(fields):{
	<tr>
		<td class="$if(!mailcss)$fieldlabel$endif$"> $it.label$</td>
		<td class="$if(mailcss)$data$else$fieldvalue$endif$">$it.value$</td>
	</tr>
}$
</table>
>>


emailerror(headline,text,error) ::= <<
$! ###### EMAIL error message ###### !$
<div class="alert alert-danger">
    <h3 class="webform_error_start">$headline$</h3>
    <p class="webform_error_text">$text$</p>
    <!--
            Error description: $error$
    //-->
</div>
>>


initerror(headline,text) ::= <<
$! ###### Initialization error message ###### !$
<div class="alert alert-warning">
    <h3 class="webform_error_start">$headline$</h3>
    <p class="webform_error_text">$text$</p>
</div>
>>