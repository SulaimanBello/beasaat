# Formspree Setup Instructions

The contact form is configured to use **Formspree** for email forwarding.

## Setup Steps

### 1. Create a Formspree Account
1. Go to [https://formspree.io](https://formspree.io)
2. Sign up for a free account (allows 50 submissions/month)

### 2. Create a New Form
1. After logging in, click **"+ New Form"**
2. Give it a name (e.g., "Beasaat Contact Form")
3. Enter the email address where you want to receive submissions (e.g., `hello@yourdomain.com`)
4. Click **"Create Form"**

### 3. Get Your Form ID
After creating the form, you'll see a form endpoint like:
```
https://formspree.io/f/xyzabc123
```
The part after `/f/` is your **Form ID** (e.g., `xyzabc123`)

### 4. Update Your Code
Open `script.js` and find this line:
```javascript
const response = await fetch('https://formspree.io/f/YOUR_FORM_ID', {
```

Replace `YOUR_FORM_ID` with your actual form ID:
```javascript
const response = await fetch('https://formspree.io/f/xyzabc123', {
```

### 5. Test It
1. Open `index.html` in your browser
2. Fill out the contact form
3. Submit it
4. Check your email inbox for the message

## Features
- ✅ No backend server required
- ✅ Free tier: 50 submissions/month
- ✅ Spam protection included
- ✅ Email notifications
- ✅ Works with static hosting (GitHub Pages, Netlify, Vercel, etc.)
- ✅ Form submission dashboard

## Optional: Custom Configuration
You can add hidden fields to your form for additional data:
```html
<input type="hidden" name="_subject" value="New Contact from Beasaat Website">
<input type="hidden" name="_cc" value="another@email.com">
```

See [Formspree documentation](https://help.formspree.io/) for more options.
