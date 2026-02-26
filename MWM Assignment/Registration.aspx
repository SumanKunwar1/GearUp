<%@ Page Title="Registration Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Registration.aspx.cs" Inherits="MWM_Assignment.Registration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <main aria-labelledby="title" class="container">
        <div class="justify-content-center align-items-center d-grid" style="min-height: 80vh">
            <div class="px-5 py-3 mx-5 bg-white rounded shadow-sm">
                <div class="row mb-5">
                    <h1 class="fw-bold mb-3">Glad to have you onboard!</h1>
                </div>
                <h3 class="text-secondary">Account Information</h3>
                <hr />
                <div class="row mb-3">
                    <div class="col-auto me-5">
                        <div class="mb-3 position-relative">
                            <a >
                                <img id="profileImage" src="/Images/Placeholder/placeholder-user.jpg" alt="Profile Image" class="profile-image" />
                            </a>
                            <asp:FileUpload runat="server" ID="fuProfile" ClientIDMode="Static" CssClass="d-none" onchange="img();" />
                            <div class="position-absolute d-flex justify-content-center align-items-center profile-image-overlay " onclick="chooseFile()">
                                <i class="bi-pencil-square text-white"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md">
                        <div class="row">
                            <div class="col-12 col-md">
                                <!-- Name input -->
                                <div class="form-floating mb-3">
                                    <asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="John Doe" Style="min-width: 100%" />
                                    <asp:Label runat="server" ID="lblName" AssociatedControlID="txtName" CssClass="form-label" Text="Name" />
                                </div>
                            </div>
                            <div class="col-12 col-md">
                                <!-- Contact input -->
                                <div class="form-floating mb-3">
                                    <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="012-34567890" Style="min-width: 100%" />
                                    <asp:Label runat="server" ID="lblPhone" AssociatedControlID="txtPhone" CssClass="form-label" Text="Contact" />
                                </div>
                            </div>
                        </div>

                        <!-- Address input -->
                        <div class="form-floating mb-3">
                            <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" TextMode="MultiLine" placeholder=" " Style="height: 8rem; min-width: 100%" />
                            <asp:Label runat="server" ID="lblAddress" AssociatedControlID="txtName" CssClass="form-label" Text="Address" />
                        </div>
                    </div>
                </div>
                <h3 class="text-secondary">Login Information</h3>
                <hr />
                <div class="row">
                    <div class="col-12">
                        <!-- Email input -->
                        <div class="form-floating mb-3">
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" autocomplete="off" placeholder="example@example.com" Style="min-width: 100%" />
                            <asp:Label runat="server" ID="lblEmail" AssociatedControlID="txtEmail" CssClass="form-label" Text="Email Address" />
                        </div>

                    </div>
                    <div class="col-12 col-md-6">
                        <!-- Password input -->
                        <div class="form-floating mb-3">
                            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" autocomplete="off" placeholder="Enter password" Style="min-width: 100%" />
                            <asp:Label runat="server" ID="lblPassword" AssociatedControlID="txtPassword" CssClass="form-label" Text="Password" />
                        </div>
                    </div>
                    <div class="col-12 col-md-6">
                        <!-- Confirm Password input -->
                        <div class="form-floating mb-3">
                            <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" autocomplete="off" placeholder="Confirm password" Style="min-width: 100%" />
                            <asp:Label runat="server" ID="lblConfirmPassword" AssociatedControlID="txtPassword" CssClass="form-label" Text="Enter your Password again" />
                        </div>
                    </div>
                </div>
                <div class="row g-0">
                    <div class="col text-center mt-3">
                        <asp:Button runat="server" ID="btnRegister" Text="Sign up" CssClass="btn btn-primary btn-lg" Style="padding-left: 2.5rem; padding-right: 2.5rem;" OnClick="btnRegister_Click" />
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
<asp:Content runat="server" ID="Content2" ContentPlaceHolderID="JSContent">

    <script type="text/javascript">

        function chooseFile() {
            document.getElementById("fuProfile").click();
        }

        function img() {
            var url = inputToURL(document.getElementById("<%= fuProfile.ClientID %>"));
            document.getElementById("profileImage").src = url;
        }

        function inputToURL(inputElement) {
            var file = inputElement.files[0];
            return window.URL.createObjectURL(file);
        }

    </script>

</asp:Content>
