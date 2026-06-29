package com.giasu.filter;

import com.giasu.model.Account;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class AuthFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpReq = (HttpServletRequest) request;
        HttpServletResponse httpRes = (HttpServletResponse) response;
        HttpSession session = httpReq.getSession(false);

        Account account = (session != null) ? (Account) session.getAttribute("account") : null;

        if (account == null) {
            httpRes.sendRedirect(httpReq.getContextPath() + "/login");
            return;
        }

        // Check admin access
        String uri = httpReq.getRequestURI();
        if (uri.contains("/admin") && account.getRole() != 3) {
            httpRes.sendRedirect(httpReq.getContextPath() + "/");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
