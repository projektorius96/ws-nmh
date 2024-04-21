let webSocket = null;

function connect() {
    webSocket = new WebSocket('ws://localhost:4040');

    webSocket.onopen = (event) => {
        keepAlive();
        webSocket.send(JSON.stringify({text: 'ping'}))
    };

    webSocket.onmessage = (event) => {
        let message = JSON.parse( event.data );
        console.log(message.text);
    };

    webSocket.onclose = (event) => {
        console.log('websocket connection closed');
        webSocket = null;
    };
}

/**
 * @tutorial
 * {@link https://developer.chrome.com/docs/extensions/how-to/web-platform/websockets}
 * 
 * Alternatively use [chrome.alarms] {@link https://developer.chrome.com/docs/extensions/develop/migrate/to-service-workers#convert-timers}
 */
function keepAlive() {
    const keepAliveIntervalId = setInterval(
        () => {
            if (webSocket) {
                webSocket.send('keepalive');
            } else {
                clearInterval(keepAliveIntervalId);
            }
        },
        // Set the interval to 20 seconds to prevent the service worker from becoming inactive.
        20 * 1000
    );
}

chrome.action.onClicked.addListener(()=>connect())