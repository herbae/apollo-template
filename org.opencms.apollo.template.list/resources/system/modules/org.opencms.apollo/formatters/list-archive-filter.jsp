<%@page
    buffer="none"
    session="false"
    trimDirectiveWhitespaces="true"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="apollo" tagdir="/WEB-INF/tags/apollo" %>

<apollo:init-messages reload="true">

<cms:formatter var="content" val="value">
<fmt:setLocale value="${cms.locale}" />
<cms:bundle basename="org.opencms.apollo.template.list.messages">

<apollo:formatter-settings
    type="${content.value.TypesToCollect}"
    parameters="${content.valueList.Parameters}"
    online="${cms.isOnlineProject}"
/>

<%-- We just want to load facet metadata here, no actual results, so the count is 0 --%>
<apollo:list-search
    source="${content.valueList.Folder}"
    types="${value.TypesToCollect}"
    categories="${content.readCategories}"
    count="0"
    sort="${value.SortOrder}"
    showexpired="${cms.element.settings.showexpired}"
    filterqueries="${value.FilterQueries}"
/>

<c:set var="csswrapper" value="${not empty formatterSettings.filterWrapper ? formatterSettings.filterWrapper : formatterSettings.listWrapper}" />
<c:set var="elementId"><apollo:idgen prefix="le" uuid="${cms.element.id}" /></c:set>

<div class="ap-list-filters ${csswrapper}">

    <c:if test="${cms.element.settings.showsearch}">
        <div class="filterbox search">
            <form role="form" class="sky-form bo-none" id="queryform" onsubmit="return false;">
                    <c:set var="escapedQuery">${fn:replace(search.controller.common.state.query,'"','&quot;')}</c:set>
                    <input type="hidden" name="${search.controller.common.config.lastQueryParam}" value="${escapedQuery}" />
                    <input type="hidden" name="${search.controller.common.config.reloadedParam}" />
                    <label class="input">
                        <i class="icon-prepend fa fa-search"></i>
                        <input
                            name="${search.controller.common.config.queryParam}"
                            id="queryinput"
                            type="text"
                            value="${escapedQuery}"
                            placeholder="<fmt:message key="apollo.list.message.search" />"
                        >
                    </label>
            </form>
        </div>
    </c:if>

    <c:if test="${cms.element.settings.showlabels and not empty fieldFacetResult and cms:getListSize(fieldFacetResult.values) > 0}">
        <div class="filterbox labels">

            <button type="button" class="btn-block btn" onclick="toggleApListFilter('labels');this.blur();">
                <span class="pull-left"><span class="fa fa-tag"></span></span>
                <span class="pull-left pl-10"><fmt:message key="apollo.list.message.labels" /></span>
                <span id="aplistlabels_toggle" class="fa fa-chevron-down ${formatterSettings.catPreopened ? 'open' : ''} pull-right"></span>
            </button>

            <div id="aplistlabels" class="dialog" ${formatterSettings.catPreopened ? 'style="display:block;"' : ''}>
                <ul>
                	<%-- BEGIN: Calculate category filters --%>
					<c:set var="catFilters"
						value="${not empty formatterSettings.catfilters ? fn:replace(formatterSettings.catfilters,' ','') : ''}" />
					<c:set var="blacklistFilter" value="true" />
					<c:if test="${not empty catFilters}">
						<c:if test="${fn:startsWith(catFilters,'whitelist:')}">
							<c:set var="catFilters"
								value="${fn:replace(catFilters,'whitelist:','')}" />
							<c:set var="blacklistFilter" value="false" />
						</c:if>
						<c:set var="catFilters" value='${fn:split(catFilters, ",")}' />
					</c:if>
					<%-- END: Calculate category filters --%>
					
					<%-- Read additional options (parameters) that influence the display of categories --%>
					<c:set var="displayCatPath" value="${fn:toLowerCase(formatterSettings.catlabelfullpath) eq 'true'}" />
					<c:set var="onlyLeafs" value="${fn:toLowerCase(formatterSettings.catshowonlyleafs) eq 'true'}" />
					
					<c:set var="facetValues" value="${fieldFacetResult.values}" />
                    <c:forEach var="value" items="${facetValues}" varStatus="outerStatus">
                    	<c:if test="${not onlyLeafs or outerStatus.last or not fn:startsWith(facetValues[outerStatus.count].name, value.name)}">
	                        <c:set var="selected">${fieldFacetController.state.isChecked[value.name] ? ' class="active"' : ''}</c:set>
	                        
	                        <%-- BEGIN: Calculate category label --%>
							<c:set var="catCompareLabel"></c:set>
							<c:set var="label"></c:set>
							<c:forEach var="category"
								items="${cms.readPathCategories[value.name]}" varStatus="status">
								<c:if test="${displayCatPath or status.last}"><c:set var="label">${label}${category.title}</c:set></c:if>
								<c:set var="catCompareLabel">${catCompareLabel}${category.title}</c:set>
								<c:if test="${not status.last}">
									<c:if test="${displayCatPath}"><c:set var="label">${label}&nbsp;/&nbsp;</c:set></c:if>
									<c:set var="catCompareLabel">${catCompareLabel} / </c:set>
								</c:if>
							</c:forEach>
							<%-- END: Calculate category label --%>
							
							<c:set var="catCompareLabel"
								value="${fn:replace(catCompareLabel,' ','')}" />
							<c:set var="isMatchedByFilter" value="false" />
							<c:forEach var="filterValue" items="${catFilters}" varStatus="status">
								<!-- Filter value: ${filterValue} -->
								<c:if test="${isMatchedByFilter or fn:contains(catCompareLabel, filterValue)}">
									<c:set var="isMatchedByFilter" value="true" />
								</c:if>
							</c:forEach>
							
	                        <c:if test="${blacklistFilter != isMatchedByFilter}">	
                                <li ${selected}>
                                    <a href="javascript:void(0)" onclick="ApolloList.filter(<%--
                                            --%>'${search.stateParameters.resetAllFacetStates.newQuery[''].checkFacetItem[categoryFacetField][value.name]}',<%--
                                            --%>'${elementId}'<%--
                                        --%>);<%--
                                        --%>ApolloList.archiveHighlight($(this));<%--
                                        --%>clearQuery();">
                                        <span class="badge"><i class="fa fa-tag"></i> ${label} (${value.count})</span>
                                    </a>
                                </li>
	                        </c:if>
                        </c:if>
                    </c:forEach>
                </ul>
            </div>
        </div>
    </c:if>

    <c:if test="${cms.element.settings.showarchive and not empty rangeFacet and cms:getListSize(rangeFacet.counts) > 0}">
        <div class="filterbox archive">

            <button type="button" class="btn-block btn" onclick="toggleApListFilter('archive');this.blur();">
                <span class="pull-left"><span class="fa fa-archive"></span></span>
                <span class="pull-left pl-10"><fmt:message key="apollo.list.message.archive" /></span>
                <span id="aplistarchive_toggle" class="fa fa-chevron-down ${formatterSettings.archivePreopened ? 'open' : ''} pull-right"></span>
            </button>

            <div id="aplistarchive" class="dialog" ${formatterSettings.archivePreopened ? 'style="display:block;"' : ''}>

                <c:set var="archiveHtml" value="" />
                <c:set var="yearHtml" value="" />
                <c:set var="prevYear" value="-1" />

                <%-- get the current year --%>
                <jsp:useBean id="now" class="java.util.Date" />
                <c:set var="thisYear"><fmt:formatDate value="${now}" pattern="yyyy" /></c:set>

                <c:forEach var="facetItem" items="${rangeFacet.counts}" varStatus="status">
                    <c:set var="selected">${rangeFacetController.state.isChecked[facetItem.value] ? ' class="active"' : ''}</c:set>
                    <fmt:parseDate var="fDate" pattern="yyyy-MM-dd'T'HH:mm:ss'Z'" value="${facetItem.value}"/>
                    <c:set var="currYear"><fmt:formatDate value="${fDate}" pattern="yyyy" /></c:set>

                    <c:if test="${prevYear != currYear}">
                        <%-- another year, generate year toggle button --%>
                        <c:if test="${not status.first}">
                            <%-- close month list of previous year --%>
                            <c:set var="yearHtml">${yearHtml}<c:out value='</ul>' escapeXml='false' /></c:set>
                        </c:if>
                        <c:set var="archiveHtml">${yearHtml}${archiveHtml}</c:set>
                        <c:set var="yearHtml">
                            <button type="button" class="btn-block btn btn-xs year" onclick="toggleApListFilter('year${currYear}');this.blur();">
                                <span class="pull-left">${currYear}</span>
                                <i id="aplistyear${currYear}_toggle" class="fa fa-chevron-down pull-right"></i>
                            </button>
                            <c:out value='<ul class="year" id="aplistyear${currYear}" style="display:none;">' escapeXml='false' />
                        </c:set>
                    </c:if>
                    <%-- add month list entry to current year --%>
                    <c:set var="yearHtml">
                        ${yearHtml}
                        <li ${selected} onclick="ApolloList.filter(<%--
                                        --%>'${search.stateParameters.resetAllFacetStates.newQuery[''].checkFacetItem[rangeFacetField][facetItem.value]}',<%--
                                        --%>'${elementId}'<%--
                                        --%>);<%--
                                    --%>ApolloList.archiveHighlight($(this).find('a'));<%--
                                    --%>clearQuery();" title="${facetItem.count}">
                            <a href="javascript:void(0)">
                                <fmt:formatDate value="${fDate}" pattern="MMM" />
                            </a>
                        </li>
                    </c:set>
                    <c:if test="${(not empty selected) or (currYear eq thisYear)}">
                        <c:set var="yearHtml">${fn:replace(yearHtml, 'style="display:none;"', '')}</c:set>
                        <c:set var="yearHtml">${fn:replace(yearHtml, 'fa-chevron-down pull-right', 'fa-chevron-down open pull-right')}</c:set>
                    </c:if>
                    <c:set var="prevYear" value="${currYear}" />
                </c:forEach>

                <%-- close month list of last year --%>
                <c:set var="archiveHtml">${yearHtml}<c:out value='</ul>' escapeXml='false' />${archiveHtml}</c:set>

                ${archiveHtml}
            </div> <%-- /ap-list-filter-archive --%>

        </div> <%-- /ap-list-filterbox-archive --%>
    </c:if>

    <script type="text/javascript">
        function toggleApListFilter(fType) {
            $("#aplist" + fType + "_toggle").toggleClass("open");
            $("#aplist" + fType + "").slideToggle();
        }

        window.onload = function () {
            $( "#queryform" ).submit(
                function( event ) {
                    ApolloList.filter(
                        "${search.stateParameters.resetAllFacetStates}&q=" + $("#queryinput").val(),
                        "${elementId}"
                    );
                    ApolloList.archiveRemoveHighlight();
                });
        }

        function clearQuery(){
            if(window.jQuery){
                $("#queryinput").val('');
            }
        }
    </script>

</div>

</cms:bundle>
</cms:formatter>

</apollo:init-messages>
