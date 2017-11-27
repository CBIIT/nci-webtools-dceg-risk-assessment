<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Q02.ascx.cs" Inherits="BCRA.Mobile.Q02" %>
<%@ Register Src="~/footer.ascx" TagPrefix="uc" TagName="footerlink" %>

<form action="Q00.aspx"method="post">
        <tr>
            <td class="q">
                2 of 7:
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label runat="server" AssociatedControlID="age">
                What is the woman's age? This tool only calculates risk for women between the ages
                of 35-85.
                </asp:Label>
            </td>
        </tr>
        <tr>
            <td class="c">
                <input type="hidden" id="q" name="q" value="2"/>
                <select name="age" id="age" runat="server">
                    <option selected="selected" value="-1000">Select</option>
                    <option>35</option>
                    <option>36</option>
                    <option>37</option>
                    <option>38</option>
                    <option>39</option>
                    <option>40</option>
                    <option>41</option>
                    <option>42</option>
                    <option>43</option>
                    <option>44</option>
                    <option>45</option>
                    <option>46</option>
                    <option>47</option>
                    <option>48</option>
                    <option>49</option>
                    <option>50</option>
                    <option>51</option>
                    <option>52</option>
                    <option>53</option>
                    <option>54</option>
                    <option>55</option>
                    <option>56</option>
                    <option>57</option>
                    <option>58</option>
                    <option>59</option>
                    <option>60</option>
                    <option>61</option>
                    <option>62</option>
                    <option>63</option>
                    <option>64</option>
                    <option>65</option>
                    <option>66</option>
                    <option>67</option>
                    <option>68</option>
                    <option>69</option>
                    <option>70</option>
                    <option>71</option>
                    <option>72</option>
                    <option>73</option>
                    <option>74</option>
                    <option>75</option>
                    <option>76</option>
                    <option>77</option>
                    <option>78</option>
                    <option>79</option>
                    <option>80</option>
                    <option>81</option>
                    <option>82</option>
                    <option>83</option>
                    <option>84</option>
                    <option>85</option>
                </select>
                
            </td>
        </tr>
        <tr>
            <td class="c">
                <input value="Next" type="submit" />
            </td>
        </tr>
        <tr>
            <td class="e h">
                <a href="Q2ex.aspx">Explanation</a>
            </td>
        </tr>
    </form>

<uc:footerlink id="footerlink" runat="server"/>