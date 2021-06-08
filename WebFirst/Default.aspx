<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WebFirst._Default" %>

<asp:Content runat="server" ID="FeaturedContent" ContentPlaceHolderID="FeaturedContent">
    <section class="featured">
        <div class="content-wrapper">
            <hgroup class="title">
                <h1><%: Title %>Welcome to my ASP.NET House.</h1>
            </hgroup>
            <p>
                I am learning ASP.NET Development together with SQL Data Management.</p>
        </div>
    </section>
</asp:Content>
<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <h3>We suggest the following:<br />
        <asp:textBox ID="txtInput" runat="server" Height="16px" Width="195px" />
        <br /><asp:Button ID="btnSearch" runat="server" Text="Search" onCLick="btnSearch_Click" Font-Size="Smaller" />
        <br /><asp:Button ID="btnClear" runat="server" Text="Clear" onClick="btnClear_Click" Font-Size="Smaller"/>
        <asp:GridView ID="GrdView" runat="server"
        Width="700"
        BackColor="#ccccff" 
        BorderColor="black"
        ShowFooter="false" 
        CellPadding="3" 
        CellSpacing="0"
        Font-Name="Verdana"
        Font-Size="8pt"
        HeaderStyle-BackColor="#aaaadd"
        EnableViewState="false" OnSelectedIndexChanged="GrdView_SelectedIndexChanged" ></asp:GridView>
    </h3>
    </asp:Content>
