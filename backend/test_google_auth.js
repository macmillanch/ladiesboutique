
async function testGoogleAuth() {
    const { default: fetch } = await import('node-fetch');
    try {
        console.log('Testing Google Auth Endpoint...');
        const response = await fetch('http://localhost:3000/api/auth/google', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                idToken: 'test-token-' + Date.now(),
                name: 'Test User',
                email: 'test' + Date.now() + '@example.com',
                photoUrl: 'https://example.com/photo.jpg',
                force_create: true
            })
        });

        const data = await response.json();
        console.log('Status Code:', response.status);
        console.log('Response:', JSON.stringify(data, null, 2));

        if (response.status === 200 && data.token) {
            console.log('✅ Google Auth Test Passed');
        } else {
            console.log('❌ Google Auth Test Failed');
        }
    } catch (error) {
        console.error('Test Error:', error);
    }
}

testGoogleAuth();
