<%@page buffer="none" session="false" trimDirectiveWhitespaces="true"%>

<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="apollo" tagdir="/WEB-INF/tags/apollo" %>

<cms:secureparams />
<fmt:setLocale value="${cms.locale}" />

<cms:bundle basename="org.opencms.apollo.template.schemas.blog">
<cms:formatter var="content" val="value">

    <c:set var="inMemoryMessage"><fmt:message key="apollo.blog.message.edit" /></c:set>
    <apollo:init-messages textnew="${inMemoryMessage}">

    <apollo:list-item-compact
        filename="${content.filename}"
        headline="${value.Title}"
        text="${content.valueList.Paragraph['0'].value.Text}"
        teaser="${value.Teaser}"
        date="${value.Date}"
        enddate="${value.EndDate}"
        datetype="both"
    />

    </apollo:init-messages>

</cms:formatter>
</cms:bundle>