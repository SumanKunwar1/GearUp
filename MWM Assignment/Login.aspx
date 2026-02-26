<%@ Page Title="Login Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="MWM_Assignment.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <main aria-labelledby="title" class="container" style="min-height: 60vh;">
        <div class="justify-content-center align-items-center my-5">
            <div class="p-5 bg-white rounded shadow-sm">
                <div class="row">
                    <h1 class="fw-bold mb-3">Glad to have you back!</h1>
                </div>
                <div class="row">
                    <div class="col-md-9 col-lg-6 col-xl-5">
                        <img src="https://mdbcdn.b-cdn.net/img/Photos/new-templates/bootstrap-login-form/draw2.webp" class="img-fluid">
                    </div>
                    <div class="col-md-8 col-lg-6 col-xl-4 offset-xl-1">
                        <!-- Email input -->
                        <div class="form-outline mb-4">
                            <asp:Label runat="server" ID="lblEmail" AssociatedControlID="txtEmail" CssClass="form-label" Text="Email Address" />
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control form-control-lg" Style="max-width: 100%" placeholder="Enter a valid email address" />
                        </div>

                        <!-- Password input -->
                        <div class="form-outline mb-3">
                            <asp:Label runat="server" ID="lblPassword" AssociatedControlID="txtPassword" CssClass="form-label" Text="Password" />
                            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control form-control-lg" TextMode="Password" Style="max-width: 100%" placeholder="Enter password" />
                        </div>

                        <!-- Forgot Password -->
                        <div class="d-flex align-items-center">
                            <a href="#!" class="text-body ms-auto">Forgot password?</a>
                        </div>

                        <div class="text-center text-lg-start mt-4 pt-2">
                            <asp:Button runat="server" ID="btnLogin" Text="Login" CssClass="btn btn-primary btn-lg" Style="padding-left: 2.5rem; padding-right: 2.5rem;" OnClick="btnLogin_Click" />
                            <p class="small fw-bold mt-2 pt-1 mb-0">Don't have an account? <a href="Registration.aspx" class="link-danger">Register</a></p>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <!-- Status Message -->
        <div runat="server" id="divStatus">
            <div class="position-fixed bottom-0 start-0 w-100">
                <div runat="server" id="statusBg" class="text-center text-md-start py-2 px-3 px-xl-5 align-items-center text-white">
                    <asp:Label runat="server" ID="lblStatusIcon" CssClass="bi-check-circle text-white h2" />
                    <asp:Label runat="server" ID="lblStatus" Text="" />
                </div>
            </div>
        </div>
        <!-- Status Message -->
    </main>
</asp:Content>
