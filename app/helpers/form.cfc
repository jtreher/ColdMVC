<cfcomponent extends="coldmvc.rendering.HTMLRenderer">

	<!------>

	<cffunction name="button" access="public" output="false" returntype="string">

		<cfreturn renderButton("button", arguments) />

	</cffunction>

	<!------>

	<cffunction name="checkbox" access="public" output="false" returntype="string">

		<cfreturn radioOrCheckbox(arguments, "checkbox") />

	</cffunction>

	<!------>

	<cffunction name="color" access="public" output="false" returntype="string">

		<cfset arguments.tag = "color" />

		<cfset append(arguments, "class", "color") />
		<cfset configure(arguments) />

		<cfoutput>
		<cfsavecontent variable="arguments.field">
			<input type="color" #arguments.common# value="#renderValue(arguments)#" />
		</cfsavecontent>
		</cfoutput>

		<cfreturn this.field(argumentCollection=arguments) />

	</cffunction>

	<!------>

	<cffunction name="date" access="public" output="false" returntype="string">

		<cfset arguments.tag = "date" />

		<cfset append(arguments, "class", "date") />
		<cfset configure(arguments) />

		<cfoutput>
		<cfsavecontent variable="arguments.field">
			<input type="date" #arguments.common# value="#renderValue(arguments)#" />
		</cfsavecontent>
		</cfoutput>

		<cfreturn this.field(argumentCollection=arguments) />

	</cffunction>

	<!------>

	<cffunction name="email" access="public" output="false" returntype="string">

		<cfset arguments.tag = "email" />

		<cfset append(arguments, "class", "email") />
		<cfset configure(arguments) />

		<cfoutput>
		<cfsavecontent variable="arguments.field">
			<input type="email" #arguments.common# value="#renderValue(arguments)#" />
		</cfsavecontent>
		</cfoutput>

		<cfreturn this.field(argumentCollection=arguments) />

	</cffunction>

	<!------>

	<cffunction name="errors" access="public" output="false" returntype="string">
		<cfargument name="errors" type="array" required="true" />

		<cfif arrayLen(arguments.errors) eq 0>
			<cfreturn "" />
		</cfif>

		<cfif not structKeyExists(arguments, "class")>
			<cfset arguments.class = variables.options.errors.class />
		</cfif>

		<cfset var content = "" />
		<cfset var error = "" />

		<cfoutput>
		<cfsavecontent variable="content">
			<cfloop array="#arguments.errors#" index="error">
				<li>#coldmvc.string.escape(error.getMessage())#</li>
			</cfloop>
		</cfsavecontent>
		</cfoutput>

		<cfreturn renderTag("ul", content, {
			class = arguments.class
		}) />

	</cffunction>

	<!------>

	<cffunction name="fieldset" access="public" output="false" returntype="string">
		<cfargument name="label" required="false" />

		<cfset arguments.tag = "fieldset" />

		<cfset configure(arguments) />

		<cfoutput>
		<cfsavecontent variable="local.string">
			<fieldset>
				<cfif arguments.label neq "">
					<legend>#arguments.label#</legend>
				</cfif>
		</cfsavecontent>
		</cfoutput>

		<cfreturn trim(local.string) />

	</cffunction>

	<!------>

	<cffunction name="form" access="public" output="false" returntype="string">
		<cfargument name="id" type="string" required="false" default="form" />
		<cfargument name="method" type="string" required="false" default="post" />

		<cfset arguments.tag = "form" />

		<!--- prevent the form tag from having unnecessary attributes --->
		<cfset arguments.name = "" />
		<cfset arguments.title = "" />

		<cfset append(arguments, "class", variables.options.form.class) />

		<cfset configure(arguments) />

		<cfset var attributes = [] />

		<cfset arguments.url = getURL(arguments) />
		<cfif arguments.url neq "">
			<cfset arrayAppend(attributes, 'action="#arguments.url#"') />
		</cfif>

		<cfif not structKeyExists(arguments, "enctype")>
			<cfset arguments.enctype = variables.options.form.enctype />
		</cfif>

		<cfset var key = "" />
		<cfloop list="method,enctype" index="i">
			<cfif arguments[i] neq "">
				<cfset arrayAppend(attributes, '#i#="#arguments[i]#"') />
			</cfif>
		</cfloop>

		<cfif arguments.common neq "">
			<cfset arrayAppend(attributes, arguments.common) />
		</cfif>

		<cfif structKeyExists(arguments, "novalidate")>
			<cfset arrayAppend(attributes, "novalidate") />
		</cfif>

		<cfreturn '<form #arrayToList(attributes, " ")#>' />

	</cffunction>

	<!------>

	<cffunction name="hidden" access="public" output="false" returntype="string">

		<cfset arguments.tag = "hidden" />

		<cfset configure(arguments) />

		<cfoutput>
		<cfsavecontent variable="arguments.field">
			<input type="hidden" name="#arguments.name#" id="#arguments.id#" value="#renderValue(arguments)#" />
		</cfsavecontent>
		</cfoutput>

		<cfreturn arguments.field />

	</cffunction>

	<!------>

	<cffunction name="input" access="public" output="false" returntype="string">

		<cfset arguments.tag = "input" />

		<cfset configure(arguments) />

		<cfoutput>
		<cfsavecontent variable="arguments.field">
			<input type="text" #arguments.common# value="#renderValue(arguments)#" />
		</cfsavecontent>
		</cfoutput>

		<cfreturn this.field(argumentCollection=arguments) />

	</cffunction>

	<!------>

	<cffunction name="number" access="public" output="false" returntype="string">
		<cfargument name="min" required="false" />
		<cfargument name="max" required="false" />
		<cfargument name="step" required="false" />

		<cfset arguments.tag = "number" />

		<cfset append(arguments, "class", "number") />
		<cfset configure(arguments, "min,max,step") />

		<cfoutput>
		<cfsavecontent variable="arguments.field">
			<input type="number" #arguments.common# value="#renderValue(arguments)#" />
		</cfsavecontent>
		</cfoutput>

		<cfreturn this.field(argumentCollection=arguments) />

	</cffunction>

	<!------>

	<cffunction name="password" access="public" output="false" returntype="string">

		<cfset arguments.tag = "password" />

		<cfset append(arguments, "class", "password") />
		<cfset configure(arguments) />

		<cfoutput>
		<cfsavecontent variable="arguments.field">
			<input type="password" #arguments.common# value="#renderValue(arguments)#" />
		</cfsavecontent>
		</cfoutput>

		<cfreturn this.field(argumentCollection=arguments) />

	</cffunction>

	<!------>

	<cffunction name="phone" access="public" output="false" returntype="string">

		<cfset arguments.tag = "phone" />

		<cfset append(arguments, "class", "phone") />
		<cfset configure(arguments) />

		<cfoutput>
		<cfsavecontent variable="arguments.field">
			<input type="tel" #arguments.common# value="#renderValue(arguments)#" />
		</cfsavecontent>
		</cfoutput>

		<cfreturn this.field(argumentCollection=arguments) />

	</cffunction>

	<!------>

	<cffunction name="radio" access="public" output="false" returntype="string">

		<cfreturn radioOrCheckbox(arguments, "radio") />

	</cffunction>

	<!------>

	<cffunction name="radioOrCheckbox" access="private" output="false" returntype="string">
		<cfargument name="args" required="true" type="struct" />
		<cfargument name="type" required="true" type="string" />

		<cfset var i = "" />

		<cfset arguments.args.tag = arguments.type />

		<cfset configure(arguments.args) />
		<cfset configureOptions(arguments.args) />

		<cfset var length = arrayLen(arguments.args.options) />

		<cfset var optionID = arguments.args.id />
		
		<cfif length neq 0>
			<cfset arguments.args.id = "#arguments.args.id#_1" />
		</cfif>

		<cfif not structKeyExists(arguments.args, "align")>
			<cfif length gt 2>
				<cfset arguments.args.align = "vertical" />
			<cfelse>
				<cfset arguments.args.align = "horizontal" />
			</cfif>
		</cfif>

		<cfif not structKeyExists(arguments.args, "hiddenField")>
			<cfset arguments.args.hiddenField = true />
		</cfif>

		<cfoutput>
		<cfsavecontent variable="arguments.args.field">
			<cfif arguments.args.hiddenField>
				<!--- make sure the form field gets submitted even if a value isn't selected --->
				<input type="hidden" name="#arguments.args.name#" value="" />
			</cfif>
			<#variables.options[arguments.type].tag# class="#variables.options[arguments.type].class# #arguments.type# #arguments.args.align#">
				<cfloop from="1" to="#length#" index="i">
					<li <cfif i eq 1>class="first"<cfelseif i eq local.length>class="last"</cfif>>
                        <label for="#arguments.args.name#_#i#" title="#htmlEditFormat(arguments.args.options[i].title)#">
							<input type="#arguments.type#" name="#arguments.args.name#" id="#optionID#_#i#" value="#htmlEditFormat(arguments.args.options[i].id)#" title="#htmlEditFormat(arguments.args.options[i].title)#" <cfif listFindNoCase(arguments.args.value, arguments.args.options[i].id) or (arguments.args.value eq arguments.args.options[i].id)>checked="checked"</cfif> #arguments.args.events#>
							<span>#htmlEditFormat(arguments.args.options[i].name)#</span>
						</label>
					</li>
				</cfloop>
			</#variables.options[arguments.type].tag#>
		</cfsavecontent>
		</cfoutput>

		<cfreturn this.field(argumentCollection=arguments.args) />

	</cffunction>

	<!------>

	<cffunction name="range" access="public" output="false" returntype="string">

		<cfset arguments.tag = "range" />

		<cfset append(arguments, "class", "range") />
		<cfset configure(arguments, "min,max,step") />

		<cfoutput>
		<cfsavecontent variable="arguments.field">
			<input type="range" #arguments.common# value="#renderValue(arguments)#" />
		</cfsavecontent>
		</cfoutput>

		<cfreturn this.field(argumentCollection=arguments) />

	</cffunction>

	<!------>

	<cffunction name="renderButton" access="private" output="false" returntype="string">
		<cfargument name="type" required="true" type="string" />
		<cfargument name="args" required="true" type="struct" />

		<cfset arguments.args.tag = arguments.type />
		<cfset append(arguments.args, "class", variables.options.button.class) />

		<cfset arguments.args.url = getURL(arguments.args) />
		<cfif arguments.args.url neq "">
			<cfset arguments.args.onclick = "window.location='#htmlEditFormat(arguments.args.url)#';" />
		</cfif>

		<cfset configure(arguments.args) />

		<cfset var result = '<input type="#arguments.type#" #arguments.args.common# value="#htmlEditFormat(arguments.args.label)#" />' />

		<cfif variables.options.button.display>

			<cfoutput>
			<cfsavecontent variable="result">
				<#variables.options.button.tag# class="#variables.options.button.class#">
					#result#
				</#variables.options.button.tag#>
			</cfsavecontent>
			</cfoutput>

		</cfif>

		<cfreturn result />

	</cffunction>

	<!------>

	<cffunction name="reset" access="public" output="false" returntype="string">

		<cfreturn renderButton("reset", arguments) />

	</cffunction>

	<!------>

	<cffunction name="search" access="public" output="false" returntype="string">

		<cfset arguments.tag = "search" />

		<cfset append(arguments, "class", "search") />
		<cfset configure(arguments) />

		<cfoutput>
		<cfsavecontent variable="arguments.field">
			<input type="search" #arguments.common# value="#renderValue(arguments)#" />
		</cfsavecontent>
		</cfoutput>

		<cfreturn this.field(argumentCollection=arguments) />

	</cffunction>

	<!------>

	<cffunction name="select" access="public" output="false" returntype="string">
		<cfargument name="blankKey" required="false" default="" type="string" />
		<cfargument name="multiple" required="false" default="false" />

		<cfset var option = "" />

		<cfset arguments.tag = "select" />

		<cfset var attributes = [] />

		<cfif arguments.multiple>

			<cfif not structKeyExists(arguments, "size")>
				<cfset arguments.size = 5 />
			</cfif>

			<cfif not structKeyExists(arguments, "blank")>
				<cfset arguments.blank = false />
			</cfif>

		</cfif>

		<cfif not structKeyExists(arguments, "blank")>
			<cfset arguments.blank = true />
		</cfif>

		<cfset configure(arguments) />
		<cfset configureOptions(arguments) />

		<cfif not structKeyExists(arguments, "blankValue")>
			<cfset arguments.blankValue = "- #arguments.label# -" />
		</cfif>

		<cfif not structKeyExists(arguments, "blankTitle")>
			<cfset arguments.blankTitle = arguments.label />
		</cfif>

		<cfset var attributes = [ arguments.common ] />

		<cfif arguments.multiple>

			<cfset arrayAppend(attributes, 'multiple="true"') />

			<cfset var selected = coldmvc.list.toStruct(arguments.value) />

		<cfelse>

			<cfset var selected = {} />
			<cfset selected[arguments.value] = true />

		</cfif>

		<cfif not structKeyExists(arguments, "hiddenField")>
			<cfset arguments.hiddenField = true />
		</cfif>

		<cfoutput>
		<cfsavecontent variable="arguments.field">
			<cfif arguments.multiple and arguments.hiddenField>
				<!--- make sure the form field gets even if a value isn't selected --->
				<input type="hidden" name="#arguments.name#" value="" />
			</cfif>
			<select #arrayToList(attributes, " ")#>
				<cfif arguments.blank>
					<option value="#htmlEditFormat(arguments.blankKey)#" title="#htmlEditFormat(arguments.blankTitle)#">#htmlEditFormat(arguments.blankValue)#</option>
				</cfif>
				<cfloop array="#arguments.options#" index="option">
					<option value="#htmlEditFormat(option.id)#" title="#htmlEditFormat(option.title)#" <cfif structKeyExists(selected, option.id)>selected</cfif>>#htmlEditFormat(option.name)#</option>
				</cfloop>
			</select>
		</cfsavecontent>
		</cfoutput>

		<cfreturn this.field(argumentCollection=arguments) />

	</cffunction>

	<!------>

	<cffunction name="submit" access="public" output="false" returntype="string">
		<cfargument name="name" required="false" default="save" />

		<cfset arguments.tag = "submit" />
		<cfset append(arguments, "class", variables.options.submit.class) />
		<cfset append(arguments, "class", variables.options.button.class) />

		<cfset configure(arguments) />

		<cfset var result = '<input type="submit" #arguments.common# value="#htmlEditFormat(arguments.label)#" />' />

		<cfif variables.options.button.display>

			<cfoutput>
			<cfsavecontent variable="result">
				<#variables.options.button.tag# class="#variables.options.button.class#">
					#result#
				</#variables.options.button.tag#>
			</cfsavecontent>
			</cfoutput>

		</cfif>

		<cfreturn result />

	</cffunction>

	<!------>

	<cffunction name="text" access="public" output="false" returntype="string">

		<cfset arguments.tag = "text" />

		<cfset configure(arguments) />

		<cfif arguments.escape>
			<cfset var content = coldmvc.string.escape(arguments.value) />
		<cfelse>
			<cfset var content = arguments.value />
		</cfif>

		<cfset arguments.field = renderTag(variables.options.text.tag, content, {
			class = variables.options.text.class
		}) />

		<cfreturn this.field(argumentCollection=arguments) />

	</cffunction>

	<!------>

	<cffunction name="textarea" access="public" output="false" returntype="string">

		<cfset arguments.tag = "textarea" />

		<cfset configure(arguments) />

		<cfoutput>
		<cfsavecontent variable="arguments.field">
			<textarea #arguments.common#>#renderValue(arguments)#</textarea>
		</cfsavecontent>
		</cfoutput>

		<cfreturn this.field(argumentCollection=arguments) />

	</cffunction>

	<!------>

	<cffunction name="time" access="public" output="false" returntype="string">

		<cfset arguments.tag = "time" />

		<cfset append(arguments, "class", "time") />
		<cfset configure(arguments) />

		<cfoutput>
		<cfsavecontent variable="arguments.field">
			<input type="time" #arguments.common# value="#renderValue(arguments)#" />
		</cfsavecontent>
		</cfoutput>

		<cfreturn this.field(argumentCollection=arguments) />

	</cffunction>

	<!------>

	<cffunction name="upload" access="public" output="false" returntype="string">

		<cfset arguments.tag = "upload" />

		<cfset configure(arguments) />

		<cfoutput>
		<cfsavecontent variable="arguments.field">
			<input type="file" #arguments.common# />
		</cfsavecontent>
		</cfoutput>

		<cfreturn this.field(argumentCollection=arguments) />

	</cffunction>

	<!------>

	<cffunction name="url" access="public" output="false" returntype="string">

		<cfset arguments.tag = "url" />

		<cfset append(arguments, "class", "url") />
		<cfset configure(arguments) />

		<cfoutput>
		<cfsavecontent variable="arguments.field">
			<input type="url" #arguments.common# value="#renderValue(arguments)#" />
		</cfsavecontent>
		</cfoutput>

		<cfreturn this.field(argumentCollection=arguments) />

	</cffunction>

	<!------>

</cfcomponent>