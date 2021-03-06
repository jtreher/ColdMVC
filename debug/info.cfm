<cfsilent>
<cfset debugManager = coldmvc.framework.getBean("debugManager") />
<cfset requestContext = coldmvc.framework.getBean("requestManager").getRequestContext() />
<cfset appVersion = debugManager.getAppVersion() />
</cfsilent>

<cfoutput>
<h2>ColdMVC Debug Information</h2>
<div class="coldmvc_debug_section">
	<table>
		<tbody>
			<cfif appVersion neq "">
				<tr>
					<td class="coldmvc_label">App Version:</td>
					<td class="coldmvc_field">#appVersion#</td>
				</tr>
			</cfif>
			<tr>
				<td class="coldmvc_label">ColdMVC Version:</td>
				<td class="coldmvc_field">#debugManager.getFrameworkVersion()#</td>
			</tr>
			<tr>
				<td class="coldmvc_label">Module:</td>
				<td class="coldmvc_field">#requestContext.getModule()#</td>
			</tr>
			<tr>
				<td class="coldmvc_label">Controller:</td>
				<td class="coldmvc_field">#requestContext.getController()#</td>
			</tr>
			<tr>
				<td class="coldmvc_label">Action:</td>
				<td class="coldmvc_field">#requestContext.getAction()#</td>
			</tr>
			<tr>
				<td class="coldmvc_label">View:</td>
				<td class="coldmvc_field">#requestContext.getView()#</td>
			</tr>
			<tr>
				<td class="coldmvc_label">Layout:</td>
				<td class="coldmvc_field">#requestContext.getLayout()#</td>
			</tr>
			<tr>
				<td class="coldmvc_label">Format:</td>
				<td class="coldmvc_field">#requestContext.getFormat()#</td>
			</tr>
			<tr>
				<td class="coldmvc_label">Route Pattern:</td>
				<td class="coldmvc_field">#requestContext.getRoutePattern()#</td>
			</tr>
			<tr>
				<td class="coldmvc_label">Route Name:</td>
				<td class="coldmvc_field">#requestContext.getRouteName()#</td>
			</tr>
			<tr>
				<td class="coldmvc_label">Status:</td>
				<td class="coldmvc_field">#debugManager.getStatus()#</td>
			</tr>
			<tr>
				<td class="coldmvc_label">Environment:</td>
				<td class="coldmvc_field">#debugManager.getEnvironment()#</td>
			</tr>
			<tr>
				<td class="coldmvc_label">Development:</td>
				<td class="coldmvc_field">#debugManager.getDevelopment()#</td>
			</tr>
			<tr>
				<td class="coldmvc_label">Reloaded:</td>
				<td class="coldmvc_field">#debugManager.getReloaded()# (<a href="#debugManager.getReloadURL()#">reload</a>)</td>
			</tr>
		</tbody>
	</table>
</div>
</cfoutput>